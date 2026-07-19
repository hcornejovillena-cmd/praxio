install.packages(c("shiny", "bslib", "ggplot2", "DT"))

# ==================
# CORRER LOCALMENTE
# ==================

shiny::runApp()

# ========================
# CARGAR LA APP EN LA WEB
# ========================

rsconnect::deployApp() #publicar