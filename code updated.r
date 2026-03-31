# ============================================================================
# PHYTOPATOMETRY IN R WITH THE PACKAGE PLIMAN - FIXED VERSION
# ============================================================================
# This script includes error handling for image imports and palette plotting

# Install pliman package (run once if needed)
# devtools::install_github("TiagoOlivoto/pliman")
# devtools::install_github("TiagoOlivoto/pliman", build_vignettes = TRUE)

# Load the library
library(pliman)

# ============================================================================
# SETUP: Define image directory
# ============================================================================
path_soy <- "C:/Users/00090473/RWD"   # Directory where images are stored

# Verify the directory exists
if (!dir.exists(path_soy)) {
  stop(paste("Directory does not exist:", path_soy))
}

# ============================================================================
# IMPORT IMAGES WITH ERROR HANDLING
# ============================================================================
cat("Importing images...\n")

# Import main image
img <- image_import("leaf.jpg", path = path_soy)
if (is.null(img)) {
  stop("Failed to import leaf.jpg. Check file exists in:", path_soy)
}
cat("✓ leaf.jpg imported successfully\n")

# Import healthy reference image
healthy <- image_import("healthy.jpg", path = path_soy)
if (is.null(healthy)) {
  stop("Failed to import healthy.jpg. Check file exists in:", path_soy)
}
cat("✓ healthy.jpg imported successfully\n")

# Import symptoms reference image
symptoms <- image_import("sympt.jpg", path = path_soy)
if (is.null(symptoms)) {
  stop("Failed to import sympt.jpg. Check file exists in:", path_soy)
}
cat("✓ sympt.jpg imported successfully\n")

# Import background reference image
background <- image_import("back.jpg", path = path_soy)
if (is.null(background)) {
  stop("Failed to import back.jpg. Check file exists in:", path_soy)
}
cat("✓ back.jpg imported successfully\n")

# Combine and display images
cat("\nCombining images for visualization...\n")
image_combine(img, healthy, symptoms, background, ncol = 4)

# ============================================================================
# IMAGE PALETTES - WITH SAFE PLOTTING
# ============================================================================
cat("\nExtracting image palettes...\n")

pals <- image_palette(img, npal = 8)

# Verify palette was created and has data
if (is.null(pals) || is.null(pals$palette_list) || length(pals$palette_list) == 0) {
  warning("Could not create palettes. Image may have issues.")
} else {
  cat("✓ Palettes extracted successfully\n")
  
  # Safely plot the first palette
  tryCatch({
    plot(pals$palette_list[[1]])
    cat("✓ Palette plot displayed\n")
  }, error = function(e) {
    warning("Could not plot palette: ", e$message)
  })
}

# ============================================================================
# DISEASE MEASUREMENT - DEFAULT SETTINGS
# ============================================================================
cat("\nMeasuring disease with default settings...\n")

res <- measure_disease(img = img,
                       img_healthy = healthy,
                       img_symptoms = symptoms,
                       img_background = background)

cat("Disease Severity (default settings):\n")
print(res$severity)

# ============================================================================
# DISEASE MEASUREMENT - PERSONALIZED MASK
# ============================================================================
cat("\nMeasuring disease with personalized mask...\n")

res2 <- measure_disease(img = img,
                        img_healthy = healthy,
                        img_symptoms = symptoms,
                        img_background = background,
                        show_original = FALSE,  # Create a mask
                        show_contour = FALSE,   # Hide the contour line
                        col_background = "white",  # Default
                        col_lesions = "red",       # Default
                        col_leaf = "green")        # Default

cat("Disease Severity (personalized mask):\n")
print(res2$severity)

# ============================================================================
# VARIATIONS IN IMAGE PALETTES - OPTIONAL SECTION
# ============================================================================
cat("\nAttempting to import alternative reference images...\n")

# Check if alternative images exist before importing
alt_images_exist <- file.exists(file.path(path_soy, c("healthy2.jpg", "sympt2.jpg", "back2.jpg")))

if (all(alt_images_exist)) {
  cat("Alternative images found. Processing...\n")
  
  # Import alternative reference images
  healthy2 <- image_import("healthy2.jpg", path = path_soy)
  symptoms2 <- image_import("sympt2.jpg", path = path_soy)
  background2 <- image_import("back2.jpg", path = path_soy)
  
  if (!is.null(healthy2) && !is.null(symptoms2) && !is.null(background2)) {
    image_combine(healthy2, symptoms2, background2, ncol = 3)
    
    # Measure disease with alternative palettes
    res3 <- measure_disease(img = img,
                            img_healthy = healthy2,
                            img_symptoms = symptoms2,
                            img_background = background2)
    
    cat("Disease Severity (alternative palettes):\n")
    print(res3$severity)
  } else {
    warning("Some alternative images failed to import")
  }
} else {
  cat("⚠ Alternative images (healthy2.jpg, sympt2.jpg, back2.jpg) not found.\n")
  cat("  Skipping alternative palette analysis.\n")
  cat("  Missing files:", paste(which(!alt_images_exist), collapse = ", "), "\n")
}

# ============================================================================
# LESION FEATURES ANALYSIS
# ============================================================================
cat("\nAnalyzing lesion features...\n")

res4 <- measure_disease(img = img,
                        img_healthy = healthy,
                        img_symptoms = symptoms,
                        img_background = background,
                        show_features = TRUE,
                        marker = "area")

cat("Lesion Shape Features:\n")
print(head(res4$shape))

# Save lesion features to CSV
output_file <- file.path(path_soy, "Lesion_features.csv")
write.csv(res4$shape, file = output_file, row.names = FALSE)
cat("\n✓ Lesion features saved to:", output_file, "\n")

# ============================================================================
# SUMMARY
# ============================================================================
cat("\n")
cat(paste(rep("=", 70), collapse = ""), "\n")
cat("ANALYSIS COMPLETE\n")
cat(paste(rep("=", 70), collapse = ""), "\n")
cat("Results Summary:\n")
cat("  - Severity (default):       ", sprintf("%.2f%%", res$severity), "\n")
cat("  - Severity (custom mask):   ", sprintf("%.2f%%", res2$severity), "\n")
cat("  - Lesion features exported: ", output_file, "\n")
cat("\nFor more information, visit:\n")
cat("https://tiagoolivoto.github.io/pliman/articles/phytopatometry.html\n")
cat(paste(rep("=", 70), collapse = ""), "\n")
