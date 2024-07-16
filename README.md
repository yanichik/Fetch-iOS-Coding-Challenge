# Fetch-iOS-Coding-Challenge
Create your boutique-quality dessert at home

## Technical
1. **Model-View-ViewModel** architectural pattern
2. Network manager using **Swift Concurrency** (async/await) to handle network requests
   - **Singleton** design pattern
   - Includes network calls, JSON parsing, image loading, and `Result` Type error handling
3. Menu displayed in `UITableView` with customized cell (includes menu item thumbnail)
4. Detail:
   - Instructions displayed inside `UIScrollView`
   - Ingredients & measurements displayed in `UITableView`
5. View Controllers:
   - `MenuVC` and `DetailVC` manage the two views
   - Includes view model binding
   - Menu items sorted alphabetically (method in `MenuViewModel`)
6. View Models:
   - `MenuViewModel` and `DetailViewModel` manage the presentation logic for the views
7. Models:
   - `MealModel` for structure of response data from network calls
   - `MenuItemModel` for structure of each menu item in `MenuVC`

## Technical Scalability Options
1. Abstract menu to full menu options (currently limited to desserts)
2. **Factory** design pattern to create customized detail views based on menu category of selected menu item
3. Search capabilities using `UISearchController` in the navigation bar of the `MenuVC`
4. Category filtering capabilities using `UISegmentedControl` to manage filtered menu presentation states
5. `UICollectionView` to beautify menu presentation (currently using `UITableView`)

## Functionality
1. Scroll through dessert specials you can make at home
2. Select desired menu item to navigate to full instructions, ingredients, and measurements

## Current Application Features & Demonstrations

***Application Demonstration Video***

https://github.com/user-attachments/assets/e2c45156-bf59-4f31-8681-db01c0b73656



***Dessert Menu Screen***

<img src="https://github.com/user-attachments/assets/055f8c45-6847-428c-a025-90cdc47c890b" alt="Dessert Menu Screen" style="width:350px">



***Menu Item Detail Screen***

<img src="https://github.com/user-attachments/assets/2c637fde-8d38-4f40-ad45-48fc46a8f1a2" alt="Menu Item Detail Screen" style="width:350px">


