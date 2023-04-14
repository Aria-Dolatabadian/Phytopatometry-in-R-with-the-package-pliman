devtools::install_github("TiagoOlivoto/pliman")
# To build the HTML vignette use
devtools::install_github("TiagoOlivoto/pliman", build_vignettes = TRUE)


#Phytopatometry in R with the package pliman


library(pliman)

#import images 

path_soy <- "C:/Users/00090473/RWD"   # directory where the figures are stored
img <- image_import("leaf.jpg", path = path_soy)
healthy <- image_import("healthy.jpg", path = path_soy)
symptoms <- image_import("sympt.jpg", path = path_soy)
background <- image_import("back.jpg", path = path_soy)
image_combine(img, healthy, symptoms, background, ncol = 4)

#Image palettes

pals <- image_palette(img, npal = 8)


# to extract the color palettes, use the object
plot(pals$palette_list[[1]])


# default settings
res <-
  measure_disease(img = img,
                  img_healthy = healthy,
                  img_symptoms = symptoms,
                  img_background = background)


res$severity


# create a personalized mask
res2 <- 
  measure_disease(img = img,
                  img_healthy = healthy,
                  img_symptoms = symptoms,
                  img_background = background,
                  show_original = FALSE, # create a mask
                  show_contour = FALSE, # hide the contour line
                  col_background = "white", # default
                  col_lesions = "red", # default
                  col_leaf = "green") # default



res2$severity

#Variations in image palettes


# import images
healthy2 <- image_import("healthy2.jpg", path = path_soy)
symptoms2 <- image_import("sympt2.jpg", path = path_soy)
background2 <- image_import("back2.jpg", path = path_soy)
image_combine(healthy2, symptoms2, background2, ncol = 3)




res3 <-
  measure_disease(img = img,
                  img_healthy = healthy2,
                  img_symptoms = symptoms2,
                  img_background = background2)



res3$severity

#Lesion features

res4 <-
  measure_disease(img = img,
                  img_healthy = healthy,
                  img_symptoms = symptoms,
                  img_background = background,
                  show_features = TRUE,
                  marker = "area")

res4$shape



write.csv(res4$shape, file = "Lesion features.csv", row.names = FALSE)




#https://tiagoolivoto.github.io/pliman/articles/phytopatometry.html
















