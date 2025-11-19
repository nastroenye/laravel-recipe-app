USE recipe_db;

-- Roles
CREATE TABLE Roles (
    RoleID INT PRIMARY KEY AUTO_INCREMENT,
    RoleName VARCHAR(50) NOT NULL UNIQUE -- e.g., Guest, User, Admin
);

-- Users
CREATE TABLE Users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    Bio TEXT,
    Avatar VARCHAR(255), -- path to avatar image
    RoleID INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    email_verified_at DATETIME NULL,
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
);

-- Recipes
CREATE TABLE Recipes (
    RecipeID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    Image VARCHAR(255), -- path to dish image
    Instructions TEXT NOT NULL, -- preparation steps
    Time INT, -- preparation time in minutes
    UserID INT NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(id)
);

-- Ingredients
CREATE TABLE Ingredients (
    IngredientID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL
);

-- RecipeIngredients (many-to-many with quantity)
CREATE TABLE RecipeIngredients (
    RecipeID INT,
    IngredientID INT,
    Quantity VARCHAR(100),
    PRIMARY KEY (RecipeID, IngredientID),
    FOREIGN KEY (RecipeID) REFERENCES Recipes(RecipeID),
    FOREIGN KEY (IngredientID) REFERENCES Ingredients(IngredientID)
);

-- Category Types (e.g., "Cuisine", "Diet", "Meal Type")
CREATE TABLE CategoryTypes (
    CategoryTypeID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL UNIQUE -- e.g., "Cuisine"
);

-- Categories (each linked to a CategoryType)
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    CategoryTypeID INT NOT NULL,
    FOREIGN KEY (CategoryTypeID) REFERENCES CategoryTypes(CategoryTypeID)
);

-- RecipeCategories (many-to-many)
CREATE TABLE RecipeCategories (
    RecipeID INT,
    CategoryID INT,
    PRIMARY KEY (RecipeID, CategoryID),
    FOREIGN KEY (RecipeID) REFERENCES Recipes(RecipeID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Comments
CREATE TABLE Comments (
    CommentID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    RecipeID INT,
    Text TEXT NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(id),
    FOREIGN KEY (RecipeID) REFERENCES Recipes(RecipeID)
);

-- Ratings (1 user can rate 1 recipe once)
CREATE TABLE Ratings (
    RatingID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT NOT NULL,
    RecipeID INT NOT NULL,
    Score TINYINT NOT NULL CHECK (Score BETWEEN 1 AND 5),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_rating (UserID, RecipeID),
    FOREIGN KEY (UserID) REFERENCES Users(id) ON DELETE CASCADE,
    FOREIGN KEY (RecipeID) REFERENCES Recipes(RecipeID) ON DELETE CASCADE
);

-- Store information for Login
CREATE TABLE cache (
    `key` VARCHAR(191) PRIMARY KEY,
    value MEDIUMTEXT NOT NULL,
    expiration INT UNSIGNED NOT NULL
);

CREATE TABLE password_reset_tokens (
    email VARCHAR(255) NOT NULL,
    token VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NULL,
    INDEX (email)
);

CREATE TABLE Reports (
    ReportID INT AUTO_INCREMENT PRIMARY KEY,
    ReporterID INT NOT NULL,
    TargetType ENUM('comment', 'recipe', 'user') NOT NULL,
    TargetID INT NOT NULL,
    Reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    Dismissed BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (ReporterID) REFERENCES Users(id)
);

CREATE TABLE ContactMessages (
	messageID INT AUTO_INCREMENT PRIMARY KEY,
    messengerEmail VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- TEST ENTRIES
INSERT INTO CategoryTypes (Name) VALUES 
('Food Type'), 
('Cuisine'), 
('Diet or Lifestyle'), 
('Nutritional Value');

-- Ingredients
INSERT INTO Ingredients (Name) VALUES
('All-purpose flour'),
('Granulated sugar'),
('Confectioner''s sugar'),
('Cornstarch'),
('Brown sugar'),
('Baking soda'),
('Baking powder'),
('Bread crumbs'),
('Bread'),
('Pasta'),
('Crackers'),
('Corn flakes'),
('Rice'),
('Garlic'),
('Potatoes'),
('Ketchup'),
('Mustard (yellow and Dijon)'),
('Relish'),
('Mayonnaise or Miracle Whip'),
('Soy sauce'),
('Honey'),
('Vinegar (apple cider, white, and balsamic)'),
('Worcestershire sauce'),
('Hot sauce'),
('Olive oil'),
('Sesame oil'),
('Canola, vegetable, or corn oil'),
('Cooking spray'),
('Cream of chicken soup'),
('Cream of mushroom soup'),
('Chicken broth'),
('Vegetable broth'),
('Canned tomatoes'),
('Tomato paste'),
('Pasta Sauce'),
('Canned beans (kidney, black)'),
('Tuna'),
('Kosher salt'),
('Cinnamon'),
('Nutmeg'),
('Oregano'),
('Rosemary'),
('Basil'),
('Red pepper flakes'),
('Parsley flakes'),
('Garlic powder'),
('Cayenne pepper'),
('Paprika'),
('Bay leaves'),
('Vanilla extract'),
('Chili powder'),
('Ginger'),
('Lawry’s seasoned salt'),
('Adobo'),
('Lawry’s seasoned pepper'),
('Butter'),
('Minced garlic'),
('Lemons'),
('Parmesan cheese'),
('Cheddar cheese'),
('Mozzarella cheese'),
('Peas'),
('Spinach'),
('Corn'),
('Green beans'),
('Carrots'),
('Broccoli'),
('Sausage'),
('Boneless chicken breast'),
('Chicken parts (thighs, wings, legs)'),
('Ground turkey or beef'),
('Italian seasoning'),
('Cumin'),
('Curry powder'),
('Thyme'),
('Tarragon'),
('Allspice'),
('Dill');

-- Food Types
INSERT INTO Categories (Name, CategoryTypeID) VALUES
('Breakfast', 1),
('Lunch', 1),
('Dinner', 1),
('Snack', 1),
('Appetizer', 1),
('Main Course', 1),
('Side Dish', 1),
('Dessert', 1),
('Beverage', 1),
('Soup', 1);

-- Cuisine 
INSERT INTO Categories (Name, CategoryTypeID) VALUES
('Asian', 2),
('European', 2),
('African', 2),
('American', 2),
('Latin American', 2),
('Middle Eastern', 2),
('Caribbean', 2),
('Indian', 2),
('Chinese', 2),
('Japanese', 2),
('Thai', 2),
('Mexican', 2),
('Italian', 2),
('French', 2),
('Greek', 2),
('Russian', 2),
('Latvian', 2);

-- Diet or Lifestyle
INSERT INTO Categories (Name, CategoryTypeID) VALUES
('Vegan', 3),
('Vegetarian', 3),
('Gluten-Free', 3),
('Low Carb', 3),
('Keto', 3),
('Paleo', 3),
('Dairy-Free', 3),
('Halal', 3),
('Kosher', 3);

-- Nutritional Values
INSERT INTO Categories (Name, CategoryTypeID) VALUES
('High Protein', 4),
('Low Fat', 4),
('Low Sugar', 4),
('High Fiber', 4),
('Low Sodium', 4),
('High Calcium', 4),
('Iron-Rich', 4),
('Vitamin-Rich', 4);

-- Promote user "Matthew" to Admin. USED when presenting.
UPDATE Users
SET RoleID = 1
WHERE name = 'Matthew';
