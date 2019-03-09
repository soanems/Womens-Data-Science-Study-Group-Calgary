#***************************************************************************
#**Exercise 1:** What happen if you run the following code in your R script?
#***************************************************************************
x <- # This expression is incomplete


#***************************************************************************
#**Exercise 2:** In your Exercise R script, create a sequence of integer from 2000 to 2010.
#***************************************************************************
x <- 2000:2010


#***************************************************************************
#**Exercise 3:** In your Exercise R script, print and examine the vectors `x0, x1, x2, x3, x4, and x5`.
#***************************************************************************
x0 <- vector() # empty vector
x1 <- vector(length = 10) # with a pre-defined length
## with a length and type
x2 <- vector("character", length = 10)
x3 <- vector("numeric", length = 10)
x4 <- vector("integer", length = 10)
x5 <- vector("logical", length = 10)


x0
typeof(x0)
length(x0)
class(x0)
str(x0)


#***************************************************************************
#**Exercise 4:** In your Exercise R script, add two more fruits to the `char_vec`.
#***************************************************************************
char_vec <- c(char_vec, "blueberry","melon")

#***************************************************************************
#**Exercise 5:** In your Exercise R script, without running the code, guess what is the vector result.
#***************************************************************************
x<- c(10.1, "b")
y <- c(TRUE, 33)
z <- c("city", TRUE)
x
y
z

#***************************************************************************
#**Exercise 6:** In your Exercise R script, run the code above. What is the class of `x[1]`? how about `x[[1]]`?
#***************************************************************************
x <- 1:10
x <- as.list(x)
length(x)

x[1]
x[[1]]


#***************************************************************************
#**Exercise 7:** In your Exercise R script, order the fruits names by their sizes using.
#***************************************************************************

fruits <- factor(c("Apple","Blueberry","Grape","Grapefruit","Plum","Watermelon" ), 
                 levels=c("Blueberry","Grape","Plum","Apple","Grapefruit","Watermelon"))
fruits
levels(fruits)


#***************************************************************************
#**Exercise 8:** In your Exercise R script:
#***************************************************************************
#  1. Create the following data frame `df`. 
df <- data.frame(Var1 = letters[1:5], x = c(1.2,1.0,3.3,0.84,5), y = c("Apple","Apple","Orange","Banana","Coconut"),z = c("yes","yes","no","no","no"), k = round(rnorm(5,15),2)) 
df

#2. Change the variable names (Var1, x, y, z, k) to (ID,Cost_unit,Fruit,Color_red,Price)
names(df) <- c("ID","Cost_unit","Fruit","Color_red","Price")

#3. Order the `Fruit` levels as (Banana < Apple < Orange < Coconut) and `Color_red` levels as (no < yes)  
df$Fruit <- factor(df$Fruit, levels = c("Banana","Apple","Orange", "Coconut"))
df$Fruit
levels(df$Fruit)

df$Color_red <- factor(df$Color_red, levels = c("no","yes"))
df$Color_red
