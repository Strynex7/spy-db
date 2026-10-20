use EcommerceDB

db.createCollection("customers")
db.createCollection("products")

db.customers.insertMany([
    {
        customer_id: 1,
        name: "Amit",
        address: {
            city: "Pune",
            state: "Maharashtra"
        },
        orders: [
            {
                product_name: "Laptop",
                supplier: "Dell India",
                quantity: 1
            },
            {
                product_name: "Mouse",
                supplier: "Logitech India",
                quantity: 2
            }
        ]
    },
    {
        customer_id: 2,
        name: "Rahul",
        address: {
            city: "Mumbai",
            state: "Maharashtra"
        },
        orders: [
            {
                product_name: "Mobile",
                supplier: "Samsung India",
                quantity: 1
            }
        ]
    },
    {
        customer_id: 3,
        name: "Priya",
        address: {
            city: "Pune",
            state: "Maharashtra"
        },
        orders: [
            {
                product_name: "Laptop",
                supplier: "Dell India",
                quantity: 1
            }
        ]
    },
    {
        customer_id: 4,
        name: "Sneha",
        address: {
            city: "Nashik",
            state: "Maharashtra"
        },
        orders: [
            {
                product_name: "Headphones",
                supplier: "Sony India",
                quantity: 1
            }
        ]
    }
])

db.products.insertMany([
    {
        product_name: "Dell Laptop",
        category: "Electronics",
        price: 65000,
        supplier: "Dell India"
    },
    {
        product_name: "HP Laptop",
        category: "Electronics",
        price: 55000,
        supplier: "HP India"
    },
    {
        product_name: "Mobile",
        category: "Electronics",
        price: 25000,
        supplier: "Samsung India"
    },
    {
        product_name: "Office Chair",
        category: "Furniture",
        price: 12000,
        supplier: "ABC Furniture"
    }
])

db.customers.find(
    {},
    {
        _id: 0,
        name: 1,
        "address.city": 1
    }
)

db.customers.find(
    { "orders.product_name": "Laptop" },
    { _id: 0, name: 1, orders: 1 }
)

db.products.find({
    category: "Electronics",
    price: { $gt: 50000 }
})

db.customers.find(
    { "orders.supplier": "Dell India" },
    { _id: 0, name: 1, orders: 1 }
)
