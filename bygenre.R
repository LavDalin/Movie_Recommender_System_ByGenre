library(recommenderlab)

## Data pre-processing
genres <- as.data.frame(movies$genres, stringsAsFactors=FALSE)
library(data.table)
genres2 <- as.data.frame(tstrsplit(genres[,1], '[|]', type.convert=TRUE), stringsAsFactors=FALSE)
colnames(genres2) <- c(1:10)
print(genres2)

genre_list <- c("Action", "Adventure", "Animation", "Children", "Comedy", "Crime","Documentary", "Drama", "Fantasy","Film-Noir", "Horror", "Musical", "Mystery","Romance","Sci-Fi", "Thriller", "War", "Western") # we have 18 genres in total

genre_matrix <- matrix(0,10330,18) #empty matrix, 10330=no of movies+1, 18=no of genres
genre_matrix[1,] <- genre_list #set first row to genre list
colnames(genre_matrix) <- genre_list #set column names to genre list
print(genre_matrix)

#iterate through matrix
for (i in 1:nrow(genres2)) {
  for (c in 1:ncol(genres2)) {
    genmat_col = which(genre_matrix[1,] == genres2[i,c])
    genre_matrix[i+1,genmat_col] <- 1
  }
}

#convert into dataframe
genre_matrix2 <- as.data.frame(genre_matrix[-1,], stringsAsFactors=FALSE) #remove first row, which was the genre list
print(genre_matrix2)
for (c in 1:ncol(genre_matrix2)) {
  genre_matrix2[,c] <- as.integer(genre_matrix2[,c])
} #convert from characters to integers

#Create a matrix to search for a movie by genre:
years <- as.data.frame(movies$title, stringsAsFactors=FALSE)
print(years)
library(data.table)
substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}
binaryratings <- ratings
for (i in 1:nrow(binaryratings)){
  if (binaryratings[i,3] > 3){
    binaryratings[i,3] <- 1
  }
  else{
    binaryratings[i,3] <- -1
  }
}
binaryratings2 <- dcast(binaryratings, movieId~userId, value.var = "rating", na.rm=FALSE)
print(binaryratings2)
for (i in 1:ncol(binaryratings2)){
  binaryratings2[which(is.na(binaryratings2[,i]) == TRUE),i] <- 0
}
binaryratings2 = binaryratings2[,-1] #remove movieIds col. Rows are movieIds, cols are userIds
print(binaryratings2)

#Remove rows that are not rated from movies dataset
movieIds <- length(unique(movies$movieId)) #8570
print(movieIds)
ratingmovieIds <- length(unique(ratings$movieId)) #8552
print(ratingmovieIds)
movies2 <- movies[-which((movieIds %in% ratingmovieIds) == FALSE),]
rownames(movies2) <- NULL
print(movies2)
#Remove rows that are not rated from genre_matrix2
genre_matrix3 <- genre_matrix2[-which((movieIds %in% ratingmovieIds) == FALSE),]
rownames(genre_matrix3) <- NULL
print(genre_matrix3)


#Calculate dot product for User Profiles
result = matrix(0,18,706)
for (c in 1:ncol(binaryratings2)){
  for (i in 1:ncol(genre_matrix3)){
    result[i,c] <- sum((genre_matrix3[,i]) * (binaryratings2[,c]))
  }
}
print(result)
#Convert to Binary scale
for (i in 1:nrow(result)){
  if (result[i] < 0){
    result[i] <- 0
  }
  else {
    result[i] <- 1
  }
}
print(result)
i <- as.integer(readline(prompt = " enter the userid :"))
result2 <- result[i,] #First user's profile
sim_mat <- rbind.data.frame(result2, genre_matrix3)
sim_mat <- data.frame(lapply(sim_mat,function(x){as.integer(x)})) #convert data to type integer

#Calculate Jaccard distance between user profile and all movies
library(proxy)
sim_results <- dist(sim_mat, method = "Jaccard")
sim_results <- as.data.frame(as.matrix(sim_results[1:8552]))
rows <- which(sim_results == min(sim_results))
#Recommended movies
movies[rows,]