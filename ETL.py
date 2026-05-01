import requests
import pandas as pd

## Data Extraction
def extract_products():
    limit = 30
    skip = 0
    all_products = []

    url = f"https://dummyjson.com/products?limit={limit}&skip={skip}"
    response = requests.get(url)
    total = response.json()["total"]

    while skip < total:
        url = f"https://dummyjson.com/products?limit={limit}&skip={skip}"
        response = requests.get(url)
        data = response.json()

        all_products.extend(data["products"])
        skip += limit

    return pd.DataFrame(all_products)

def extract_users():
    limit = 30
    skip = 0
    all_users = []

    url = f"https://dummyjson.com/users?limit={limit}&skip={skip}"
    response = requests.get(url)
    total = response.json()["total"]

    while skip < total:
        url = f"https://dummyjson.com/users?limit={limit}&skip={skip}"
        response = requests.get(url)
        data = response.json()

        all_users.extend(data["users"])
        skip += limit

    return pd.DataFrame(all_users)


def extract_carts():
    limit = 30
    skip = 0
    all_carts = []

    url = f"https://dummyjson.com/carts?limit={limit}&skip={skip}"
    response = requests.get(url)
    total = response.json()["total"]

    while skip < total:
        url = f"https://dummyjson.com/carts?limit={limit}&skip={skip}"
        response = requests.get(url)
        data = response.json()

        all_carts.extend(data["carts"])
        skip += limit

    return all_carts   # keep as list (nested)


## Data Transformation

def transform_products(df):
    df = df[["id", "title", "category", "price", "rating", "stock","discountPercentage","warrantyInformation","returnPolicy"]]

    df = df.rename(columns={
        "id": "product_id"
    })

    df = df.drop_duplicates()
    df = df.dropna(subset=["product_id", "price"])
    df["warrantyInformation"] = df["warrantyInformation"].str.replace("warranty","")
    df["returnPolicy"] = df["returnPolicy"].str.replace("return policy","")

    return df


def transform_users(df):
    df["city"] = df["address"].apply(lambda x: x.get("city") if isinstance(x, dict) else None)
    df["state"] = df["address"].apply(lambda x: x.get("state") if isinstance(x, dict) else None)
    df["country"] = df["address"].apply(lambda x: x.get("country") if isinstance(x, dict) else None)

    df = df[[
        "id", "firstName", "lastName", "age", "gender",
        "email", "phone", "city", "state", "country"
    ]]

    df = df.rename(columns={
        "id": "customer_id",
        "firstName": "first_name",
        "lastName": "last_name"
    })

    df = df.drop_duplicates()

    return df


def transform_orders(carts):
    orders = {
        "customer_id": [],
        "product_id": [],
        "title": [],
        "price": [],
        "quantity": [],
        "total": [],
        "discount_percentage": [],
        "discounted_total": []
    }

    for cart in carts:
        user_id = cart.get("userId")

        for product in cart.get("products", []):
            orders["customer_id"].append(user_id)
            orders["product_id"].append(product.get("id"))
            orders["title"].append(product.get("title"))
            orders["price"].append(product.get("price"))
            orders["quantity"].append(product.get("quantity"))
            orders["total"].append(product.get("total"))
            orders["discount_percentage"].append(product.get("discountPercentage"))
            orders["discounted_total"].append(product.get("discountedTotal"))

    df = pd.DataFrame(orders)

    df = df.drop_duplicates()
    df = df.dropna(subset=["customer_id", "product_id"])

    df["order_id"] = range(1, len(df) + 1)

    return df


##  Data Loading

def load_to_csv(df, path):
    df.to_csv(path, index=False)


## pipeline

def run_pipeline():
    print("Extracting data...")

    products_raw = extract_products()
    users_raw = extract_users()
    carts_raw = extract_carts()

    print("Transforming data...")

    products = transform_products(products_raw)
    users = transform_users(users_raw)
    orders = transform_orders(carts_raw)

    print("Saving data...")

    load_to_csv(products, "products_cleaned.csv")
    load_to_csv(users, "users_cleaned.csv")
    load_to_csv(orders, "orders_cleaned.csv")

    print("ETL pipeline completed successfully!")


if __name__ == "__main__":
    run_pipeline()
