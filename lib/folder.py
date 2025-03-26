import os

# Define the base directory (change this path if needed)
base_dir = r"C:\Users\print\StudioProjects\efood\lib"

# Define the folder structure with empty files
folder_structure = {
    "core": ["app_constants.dart", "theme.dart", "routes.dart"],
    "data/models": ["user_model.dart", "product_model.dart", "order_model.dart"],
    "data/services": ["auth_service.dart", "firestore_service.dart", "storage_service.dart"],
    "controllers": ["auth_controller.dart", "home_controller.dart", "cart_controller.dart", "order_controller.dart"],
    "providers": ["cart_provider.dart", "order_provider.dart"],
    "views/auth": ["login_screen.dart", "register_screen.dart"],
    "views/home": ["home_screen.dart", "product_detail_screen.dart"],
    "views/cart": ["cart_screen.dart"],
    "views/orders": ["order_screen.dart"],
    "views/profile": ["profile_screen.dart"],
    "widgets": ["custom_button.dart", "product_card.dart", "order_card.dart"],
    "utils": ["helpers.dart", "validators.dart"],
    "bindings": ["auth_binding.dart", "home_binding.dart", "cart_binding.dart", "order_binding.dart"]
}

# Create the base directory if it doesn't exist
os.makedirs(base_dir, exist_ok=True)

# Create main.dart in the base directory
with open(os.path.join(base_dir, "main.dart"), "w") as f:
    f.write("// main.dart\n")

# Create folders and files
for folder, files in folder_structure.items():
    folder_path = os.path.join(base_dir, folder)
    os.makedirs(folder_path, exist_ok=True)

    for file in files:
        file_path = os.path.join(folder_path, file)
        with open(file_path, "w") as f:
            f.write(f"// {file}\n")

print(f"✅ Flutter project structure created successfully in: {base_dir}")
