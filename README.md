# Movie_Recommender_System_ByGenre
A recommendation system is a type of information filtering system which challenges to assume the priorities of a user, and make recommendations on the basis of user’s priorities. Recommendation systems help users find and select items (e.g., books, movies, restaurants) from the huge number available on the web or in other electronic information sources.

Here we are using Content Based Filtering to create a Recommener system that will movies based on the similarity between the content (e.g., genres, directors, actors) of the movies a user has already liked and the content of new movies. It uses movie features instead of user preferences, focusing on matching items based on their properties. Content Based Recommendation algorithm takes into account the likes and dislikes of the user and generates a User Profile. For generating a user profile, we take into account the item profiles( vector describing an item) and their corresponding user rating. The user profile is the weighted sum of the item profiles with weights being the ratings user rated. Once the user profile is generated, we calculate the similarity of the user profile with all the items in the dataset

# Dataset used

GroupLens Research has collected and made available rating data sets from the MovieLens web site (http://movielens.org). MovieLens 100K movie ratings. Stable benchmark dataset. 100,000 ratings from 1000 users on 1700 movies. Released 4/1998
