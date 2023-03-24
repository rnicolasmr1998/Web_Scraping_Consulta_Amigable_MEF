
  '*********************************************************************************
  # PROYECTO: 		  WEB SCRAPPING - CONSULTA AMIGABLE (MEF)
  # TÍTULO:         FINANCIAMIENTO DE UNIVERSIDADES PÚBLICAS (2010-2022)
  # AUTOR: 			    RENZO NICOLAS MARROQUIN RUBIO
  # FECHA:				  28/01/2023
  *********************************************************************************'

  # Outline: -----------------------------------------------------------------------

  {'
  1. Ruta de trabajo y globals
    1.1. Instalar paquetes requeridos
    1.2. Configurar usuarios
    1.3. Configurar carpetas
    1.4. Configurar ejecución
  2. Descargar base de datos
  3. Importar base de datos
  4. Limpieza de base de datos
  5. Resultados de base de datos
  '}

  # ********************************************************************************
  # PART 1: Ruta de trabajo y globals ----------------------------------------------
  # ********************************************************************************
  
  rm(list = ls())
  cat("\014")
  
  ## 1.1. Instalar librerias requeridas --------------------------------------------
  
  if (!require("pacman")) {install.packages("pacman")}
  pacman::p_load("xml2", "stringr", "httr","RSelenium", "webdriver", "netstat")
  
  ## 1.2. Configurar usuarios ------------------------------------------------------
  
  if (Sys.info()[["user"]] == "rnico") {
    setwd("C:/Users/rnico/Documents/02_Sunedu")
  }
  
  if (Sys.info()[["user"]] == "renzomarroquin") { 
    setwd("D:/NICOLAS")
  }
  
  if (Sys.info()[["user"]] == "PIERO ALEJANDRO") { 
    setwd("D:/Nicolas/01_Sunedu")
  }
  
  ## 1.3. Configurar carpetas ------------------------------------------------------
  
  proyecto       <- paste(getwd(),  "01_Web_scraping",   sep = "/")
  base_de_datos  <- paste(proyecto, "01_Base_de_Datos",  sep = "/")
  codigo         <- paste(proyecto, "02_Codigo",         sep = "/")
  resultados     <- paste(proyecto, "03_Resultados",     sep = "/")
  documentacion  <- paste(proyecto, "04_Documentacion",  sep = "/")
  alerta         <- paste(proyecto, "05_Alerta",         sep = "/")
  
  # ********************************************************************************
  # PART 2: Conexión al navegador --------------------------------------------------
  # ********************************************************************************
  
  ## 2.1. Firefox ------------------------------------------------------------------
  
  ubicacion_arch <- base_de_datos %>% str_replace_all("/", "\\\\\\\\")
  fprof_firefoz  <- makeFirefoxProfile(list(browser.download.dir = ubicacion_arch,
                                            browser.download.folderList = 2L,
                                            browser.download.manager.showWhenStarting = FALSE,
                                            browser.helperApps.neverAsk.saveToDisk="text/plain,text/x-csv,text/csv,application/ms-excel,application/vnd.ms-excel,application/csv,application/x-csv,text/csv,text/comma-separated-values,text/x-comma-separated-values,text/tab-separated-values,application/pdf",
                                            browser.tabs.remote.autostart = FALSE,
                                            browser.tabs.remote.autostart.2 = FALSE,
                                            browser.tabs.remote.desktopbehavior = FALSE))
  
  rD_firefox     <- rsDriver(port      = sample(7600)[1], 
                             browser   = "firefox",  
                             iedrver   = NULL, 
                             verbose   = TRUE, 
                             check     = TRUE, 
                             chromever = NULL, 
                             extraCapabilities = fprof_firefoz)
  
  ## 2.2. Acceso al "client" -------------------------------------------------------
  
  remDr_firefox  <- rD_firefox$client
  
  ### 2.2.1. Navegacióm ------------------------------------------------------------
  
  url_consulta   <- "http://apps5.mineco.gob.pe/transparencia/Navegador/Navegar.aspx"
  remDr_firefox$navigate(url_consulta)
  
  ### 2.2.2. HTML de la página -----------------------------------------------------
  
  html_consulta  <- remDr_firefox$findElement("xpath","/html")
  html_consulta  <- html_consulta$getElementAttribute("outerHTML")
  
  # ********************************************************************************
  # PART 3: Descargar archivos -----------------------------------------------------
  # ********************************************************************************
  
  ## 3.1 Variables de control --------------------------------------------------
  
  url_consulta   <- "https://apps5.mineco.gob.pe/transparencia/Navegador/Navegar.aspx"
  años_mef        <- c(2022:2010)
  
  ## 3.2. URL de descarga ----------------------------------------------------------
  
  for (año in años_mef) {
    
    remDr_firefox$navigate(paste0(url_consulta, "?y=", año, "&ap=ActProy"))
  
  ## 3.3. Selección de opciones para (2022-2004) ------------------------------------  
    
    if (año >= 2005) {
      
  ### 3.3.1. Nivel de Gobierno - Total ----------------------------------------------
  
      click_nacional <- remDr_firefox$findElement("xpath",
                                                  "//*[@id='ctl00_CPH1_BtnTipoGobierno']")
      click_nacional$clickElement()
  
  #### 3.3.2. Sector - Gobierno Nacional ---------------------------------------------
  
  ### 3.3.2.1. Gobierno Nacional ----------------------------------------------------
  
      click_gob_nac  <- remDr_firefox$findElement("xpath",
                                                  "//*[@id='ctl00_CPH1_RptData_ctl01_TD0']")
      click_gob_nac$clickElement()
  
  ### 3.3.2.2. Sector ---------------------------------------------------------------
  
      click_sector   <- remDr_firefox$findElement("xpath",
                                                  "//*[@id='ctl00_CPH1_BtnSector']")
      click_sector$clickElement()
  
  ### 3.3.3. Pliego - Sector --------------------------------------------------------
  
  ### 3.3.3.1. Sector ---------------------------------------------------------------
  
      click_sector   <- remDr_firefox$findElement("xpath",
                                                  "//*[@id='ctl00_CPH1_RptData_ctl09_TD0']")
      click_sector$clickElement()
  
  ### 3.3.3.2. Pliego ---------------------------------------------------------------
  
      click_pliego   <- remDr_firefox$findElement("xpath",
                                                  "//*[@id='ctl00_CPH1_BtnPliego']")
      click_pliego$clickElement()
  
  ## 3.3.4. Descargar archivos --------------------------------------------------------

      click_descarga <- remDr_firefox$findElement("xpath",
                                                  "//*[@id='ctl00_CPH1_lbtnExportar']")
      click_descarga$clickElement()
      
    } else {
     
  ## 3.4. Selección de opciones para (2004-1999) ------------------------------------    
  
  ### 3.4.1. Total - Sector ---------------------------------------------------------
      
      click_sector   <- remDr_firefox$findElement("xpath",
                                                  "//*[@id='ctl00_CPH1_BtnSector']")
      click_sector$clickElement()
      
  ### 3.3.3. Pliego - Sector --------------------------------------------------------
      
  ### 3.3.3.1. Sector ---------------------------------------------------------------
      
      click_sector   <- remDr_firefox$findElement("xpath",
                                                  "//*[@id='ctl00_CPH1_RptData_ctl07_TD0']")
      click_sector$clickElement()
      
  ### 3.3.3.2. Pliego ---------------------------------------------------------------
      
      click_pliego   <- remDr_firefox$findElement("xpath",
                                                  "//*[@id='ctl00_CPH1_BtnPliego']")
      click_pliego$clickElement()
      
  ## 3.3.4. Descargar archivos --------------------------------------------------------
      
      click_descarga <- remDr_firefox$findElement("xpath",
                                                  "//*[@id='ctl00_CPH1_lbtnExportar']")
      click_descarga$getElementAttribute("href")
      click_descarga$clickElement()    
      
    }
  }
  
  ## 3.5. Cerramos conexión --------------------------------------------------------
  
  remDr_firefox$close()
  
