import UIKit

struct OriginDataProvider {
    static func getOrigins() -> [RestaurantOrigin] {
        return [
            // 1. Wing Snob
            RestaurantOrigin(
                restaurantId: "1",
                restaurantName: "Wing Snob",
                themeColor: UIColor(red: 0.99, green: 0.80, blue: 0.28, alpha: 1.0),
                tagline: "The Saucy Revolution",
                slides: [
                    OriginSlide(
                        title: "Chapter 1: The Craving",
                        subtitle: "Detroit, 2017",
                        storyText: "Two wing fanatics got tired of boring, dry chicken. They swore an oath: 'Every wing deserves a flavor masterpiece!'",
                        imageName: "flame.fill",
                        menuHighlight: "🔥 Hot Buffalo & Honey BBQ"
                    ),
                    OriginSlide(
                        title: "Chapter 2: Flavor Lab",
                        subtitle: "Sauce Experiments",
                        storyText: "In a small kitchen, they crafted over 15 unique sauces — from Sweet Chili Lou to Snob Sauce.",
                        imageName: "drop.fill",
                        menuHighlight: "🍗 Boneless Tenders & Loaded Fries"
                    )
                ]
            ),
            
            // 2. Anthony's Coal Fired Pizza
            RestaurantOrigin(
                restaurantId: "2",
                restaurantName: "Anthony's Coal Fired",
                themeColor: UIColor(red: 0.90, green: 0.80, blue: 0.95, alpha: 1.0),
                tagline: "Born from 900° Flames",
                slides: [
                    OriginSlide(
                        title: "Chapter 1: The Coal Secret",
                        subtitle: "Florida, 2002",
                        storyText: "Anthony Bruno couldn't find authentic New York style pizza in Florida. So he built a custom 900° coal-burning oven!",
                        imageName: "fireplace.fill",
                        menuHighlight: "🍕 Coal Fired Traditional Pie"
                    ),
                    OriginSlide(
                        title: "Chapter 2: Crispy Perfection",
                        subtitle: "The Well-Done Crust",
                        storyText: "The secret isn't just the heat — it's the charred, crispy crust and jumbo wings roasted in coal heat.",
                        imageName: "bolt.fill",
                        menuHighlight: "🍗 Coal Oven Roasted Wings"
                    )
                ]
            ),
            
            // 3. Dewey's Pizza
            RestaurantOrigin(
                restaurantId: "3",
                restaurantName: "Dewey's Pizza",
                themeColor: UIColor(red: 0.72, green: 0.78, blue: 0.96, alpha: 1.0),
                tagline: "The Art of the Dough Toss",
                slides: [
                    OriginSlide(
                        title: "Chapter 1: Taking Flight",
                        subtitle: "Cincinnati, 1998",
                        storyText: "Dewey's started with a simple vision: open kitchens where guests can watch dough fly through the air like magic!",
                        imageName: "sparkles",
                        menuHighlight: "🍕 Tito Santana & Green Lantern"
                    )
                ]
            ),

            // 4. Dion's
            RestaurantOrigin(
                restaurantId: "4",
                restaurantName: "Dion's",
                themeColor: UIColor(red: 0.68, green: 0.85, blue: 0.70, alpha: 1.0),
                tagline: "The Southwest Legend",
                slides: [
                    OriginSlide(
                        title: "Chapter 1: The Great Experiment",
                        subtitle: "Albuquerque, 1978",
                        storyText: "Two Greek friends bought a small pizza shop on a whim. Their green chile pizzas instantly became a New Mexico icon!",
                        imageName: "sun.max.fill",
                        menuHighlight: "🥪 Green Chile Subs & Ranch Dressing"
                    )
                ]
            ),

            // 5. Marco's Pizza
            RestaurantOrigin(
                restaurantId: "5",
                restaurantName: "Marco's Pizza",
                themeColor: UIColor(red: 0.96, green: 0.74, blue: 0.72, alpha: 1.0),
                tagline: "Authentic Italian Roots",
                slides: [
                    OriginSlide(
                        title: "Chapter 1: From Italy to USA",
                        subtitle: "Toledo, 1978",
                        storyText: "Founder Pasquale 'Pat' Giammarco grew up in Italy making sauce from scratch. He brought his secret family recipe across the ocean.",
                        imageName: "heart.fill",
                        menuHighlight: "🧀 Signature 3-Cheese Blend Pie"
                    )
                ]
            ),

            // 6. Dave's Hot Chicken
            RestaurantOrigin(
                restaurantId: "6",
                restaurantName: "Dave's Hot Chicken",
                themeColor: UIColor(red: 0.98, green: 0.68, blue: 0.52, alpha: 1.0),
                tagline: "From Parking Lot to Empire",
                slides: [
                    OriginSlide(
                        title: "Chapter 1: The $900 Dream",
                        subtitle: "East Hollywood, 2017",
                        storyText: "Four friends scraped together $900 to set up a tiny chicken stand in a parking lot with portable fryers and heat lamps.",
                        imageName: "flame.circle.fill",
                        menuHighlight: "🌶️ Reaper Level Tenders & Sliders"
                    )
                ]
            ),

            // 7. Jet's Pizza
            RestaurantOrigin(
                restaurantId: "7",
                restaurantName: "Jet's Pizza",
                themeColor: UIColor(red: 0.99, green: 0.85, blue: 0.62, alpha: 1.0),
                tagline: "Better, Crispier, Square",
                slides: [
                    OriginSlide(
                        title: "Chapter 1: The Square Obsession",
                        subtitle: "Sterling Heights, 1978",
                        storyText: "Eugene Jetts bought a vacant party store instead of a home. He converted it to bake deep-dish Detroit-style square pizza!",
                        imageName: "square.fill",
                        menuHighlight: "🍕 Turbo Crust Detroit Deep Dish"
                    )
                ]
            ),

            // 8. Giordano's
            RestaurantOrigin(
                restaurantId: "8",
                restaurantName: "Giordano's",
                themeColor: UIColor(red: 0.75, green: 0.86, blue: 0.72, alpha: 1.0),
                tagline: "The Deep Dish Royalty",
                slides: [
                    OriginSlide(
                        title: "Chapter 1: Mama's Stuffed Pie",
                        subtitle: "Chicago, 1974",
                        storyText: "Brothers Efren and Joseph introduced their mother's famous double-crusted cheese pie recipe from Torino, Italy to Chicago.",
                        imageName: "crown.fill",
                        menuHighlight: "🥧 Chicago Famous Stuffed Deep Dish"
                    )
                ]
            )
        ]
    }
}
