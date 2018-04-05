vertex_coordatlas <- function(glm_left, glm_right, column, thresh_left, thresh_right, atlas_left, atlas_right, aal_labels, mni) {

# Left and right atlases need to be already loaded into the environment and specified in atlas_left and atlas_right, as well as the labels file.
# The mni coordinates for each vertex has to be loaded as well.
# Column variable must be an int or char.

# Old code for loading the atlases and vertex coordinates    
#AAL_atlas_left_short <- read_csv(atlas, col_names = FALSE)  
#AAL_atlas_right_short <- read_csv(atlas, col_names = FALSE)
#AAL_labels <- read_csv(labels, col_names = c("aal","short", "label"))
#vertex_mni <- read_csv(atlas, col_names = c("x","y","z))  

# Left Hemisphere Pos
tvalue_left <- glm_left[,column]
tvalue_left_log <- tvalue_left >= thresh_left
vertex_tables_left <- mutate(mni, thresh = tvalue_left_log, vertex = 1:n(), 
                        t = tvalue_left, aal = atlas_left$X1)
vertex_tables_left_f <- filter(vertex_tables_left, thresh == TRUE) %>% 
  
  arrange(aal)

vertex_tables_left_f <- right_join(vertex_tables_left_f, aal_labels, by = "aal")

vertex_tables_left_f$label <- factor(vertex_tables_left_f$label)

vertex_tables_left_f <- na.omit(vertex_tables_left_f)

atlas_table_left <- group_by(vertex_tables_left_f,label) %>% 
  filter(t%in%max(t))
atlas_table_left <- mutate(atlas_table_left, x = round(x), y = round(y), z = round(z), t = round(t,2)) %>% 
  select(label,vertex,x,y,z,t)

# Left Hemisphere Neg
tvalue_left_neg <- glm_left[,column]
thresh_left_neg = thresh_left*(-1)
tvalue_left_log_neg <- tvalue_left_neg <= thresh_left_neg
vertex_tables_left_neg <- mutate(mni, thresh = tvalue_left_log_neg, vertex = 1:n(), 
                             t = tvalue_left_neg, aal = atlas_left$X1)
vertex_tables_left_f_neg <- filter(vertex_tables_left_neg, thresh == TRUE) %>% 
  
  arrange(aal)

vertex_tables_left_f_neg <- right_join(vertex_tables_left_f_neg, aal_labels, by = "aal")

vertex_tables_left_f_neg$label <- factor(vertex_tables_left_f_neg$label)

vertex_tables_left_f_neg <- na.omit(vertex_tables_left_f_neg)

atlas_table_left_neg <- group_by(vertex_tables_left_f_neg,label) %>% 
  filter(t%in%max(t))
atlas_table_left_neg <- mutate(atlas_table_left_neg, x = round(x), y = round(y), z = round(z), t = round(t,2)) %>% 
  select(label,vertex,x,y,z,t)

# Right Hemisphere

tvalue_right <- glm_right[,column]
tvalue_right_log <- tvalue_right >= thresh_right
vertex_tables_right <- mutate(mni, thresh = tvalue_right_log, vertex = 1:n(), 
                             t = tvalue_right, aal = atlas_right$X1)
vertex_tables_right_f <- filter(vertex_tables_right, thresh == TRUE) %>% 
  
  arrange(aal)

vertex_tables_right_f <- right_join(vertex_tables_right_f, aal_labels, by = "aal")

vertex_tables_right_f$label <- factor(vertex_tables_right_f$label)

vertex_tables_right_f <- na.omit(vertex_tables_right_f)

atlas_table_right <- group_by(vertex_tables_right_f,label) %>% 
  filter(t%in%max(t))

atlas_table_right <- mutate(atlas_table_right, x = round(x), y = round(y), z = round(z), t = round(t,2)) %>% 
  select(label,vertex,x,y,z,t)

# Right Hemisphere Neg
tvalue_right_neg <- glm_left[,column]
thresh_right_neg = thresh_right*(-1)
tvalue_right_log_neg <- tvalue_right_neg <= thresh_right_neg
vertex_tables_right_neg <- mutate(mni, thresh = tvalue_right_log_neg, vertex = 1:n(), 
                                 t = tvalue_right_neg, aal = atlas_right$X1)
vertex_tables_right_f_neg <- filter(vertex_tables_right_neg, thresh == TRUE) %>% 
  
  arrange(aal)

vertex_tables_right_f_neg <- right_join(vertex_tables_right_f_neg, aal_labels, by = "aal")

vertex_tables_right_f_neg$label <- factor(vertex_tables_right_f_neg$label)

vertex_tables_right_f_neg <- na.omit(vertex_tables_right_f_neg)

atlas_table_right_neg <- group_by(vertex_tables_right_f_neg,label) %>% 
  filter(t%in%max(t))
atlas_table_right_neg <- mutate(atlas_table_right_neg, x = round(x), y = round(y), z = round(z), t = round(t,2)) %>% 
  select(label,vertex,x,y,z,t)

atlas_table_lr <- rbind(atlas_table_left, atlas_table_left_neg, atlas_table_right, atlas_table_right_neg)

return(atlas_table_lr)
}
