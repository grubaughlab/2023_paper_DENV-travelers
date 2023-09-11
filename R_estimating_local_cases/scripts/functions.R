#options(scipen = 999)

mod_check = function(mod) {
  
  #extract the name of the model
  mod_nm = deparse(substitute(mod))
  
  t = list(
    "check_model" = check_model(mod),
    "collinearity" = check_collinearity(mod),
    "distribution" = check_distribution(mod),
    "dispersion" = check_overdispersion(mod),
    "zeroinflation" = check_zeroinflation(mod),
    #"heteroskedasticity" = check_heteroskedasticity(mod),
    "aurocorrelation" = check_autocorrelation(mod),
    "summary" = summary(mod)
    
  )
  assign(paste0(mod_nm, "_checks"), t, envir = globalenv())
  
}


make_predictions= function(mod, df) {
  df_yr_pred = df %>% 
    modelr::add_predictions(mod, 
                            type = "response") %>%
    ciTools::add_ci(mod, names = c("pred_lwr", "pred_upr")) %>%
    modelr::add_residuals(mod)  %>%
    mutate(Cases = df_yr$Cases) %>% #add back in original case data
    mutate_if(is.numeric, ~ round(.,2))
  
}

mod_fit = function(x, mod) {
  #x = the previously existing compiled model data
  #mod the model you want to add
  x_nm = deparse(substitute(x)) #get object as a string
  mod_nm = deparse(substitute(mod))
  formula = paste(mod$call$formula[2],mod$call$formula[1], mod$call$formula[3])
  
  #if the x object to write to doesn't exist create one
  if(exists(x_nm)){
    glance(mod) %>%
      mutate(model = mod_nm) %>%
      mutate(formula = formula) %>%
      rbind(x) %>%
      arrange(AIC) %>%
      distinct_all(.) %>% #incase a model is run and added twice it will remove it
      dplyr::select(model,formula, everything()) %>%
      mutate_if(is.numeric, ~ round(.,2))
  } else {
    glance(mod) %>%
      mutate(model = mod_nm) %>%
      mutate(formula = formula) %>%
      dplyr::select(model,formula, everything()) %>%
      mutate_if(is.numeric, ~ round(.,2))
  } 
  
}


mod_clean = function(x, mod) {
  #x = the previously existing compiled model data
  #mod = the model you want to add
  x_nm = deparse(substitute(x)) #get object as a string
  mod_nm = deparse(substitute(mod))
  formula = paste(mod$call$formula[2],mod$call$formula[1], mod$call$formula[3])
  
  if(exists(x_nm)) {
    t = mod %>%
      
      broom::tidy(., conf.int = T, exponentiate = T) %>%
      mutate(sig = if_else(p.value < 0.05, 1, 0)) %>%
      mutate_if(is.numeric, round, 3) %>%
      mutate(model = mod_nm) %>%
      mutate(formula = formula) %>%
      mutate(family = case_when(
        str_detect(model, "modp|mod_p|pois") ~ "pois",
        str_detect(model, "modnb|modnb|negbin") ~ "neg_bin",
        str_detect(model, "modlm|mod_lm") ~ "lm",
        TRUE ~ "unknown")
      ) %>%
      rbind(x) %>% #append to existing dataframe
      distinct_all(.) #remove any models you tried to run twice
    
  }else{
    mod %>%
      broom::tidy(., conf.int = T, exponentiate = T) %>%
      mutate(sig = if_else(p.value < 0.05, 1, 0)) %>%
      mutate_if(is.numeric, round, 3) %>%
      mutate(model = mod_nm) %>%
      mutate(formula = formula) %>%      
      mutate(family = case_when(
        str_detect(model, "modp|mod_p|pois") ~ "pois",
        str_detect(model, "modnb|modnb|negbin") ~ "neg_bin",
        str_detect(model, "modlm|mod_lm") ~ "lm",
        str_detect(model, "modbay") ~ "bayes",
        TRUE ~ "unknown")
      ) %>%
      dplyr::select(model, family, formula, term, estimate, std.error, statistic, 
                    p.value, conf.low, conf.high, sig)
    
  } 
}


plot_estimates = function(mod){
  
  if(is.data.frame(mod)) {
    ggplot(mod, aes(x = term, y = estimate, color = term)) +
      geom_point(size = 3) +
      geom_errorbar(aes(ymin=conf.low,ymax=conf.high,width=0.2)) +
      geom_hline(yintercept = 1, color = "red", linetype = "dashed") +
      theme_bw()+
      theme(axis.text.x = element_blank()) +
      theme(axis.text.x = element_text(angle = 90, size = 7),
            legend.position = "none")+
      facet_grid(family~model)
  } else {
    print("mod must be a dataframe compiled using mod_clean function")
  }
  
}


plot_pred = function(df) {
  #PREDICTED VS REPORTED OVER TIME
  
  df_nm = deparse(substitute(df))
  
  p1 = ggplot(df) +
    geom_line(aes(x = Year, y = pred), color= "darkred", size = 1) +
    geom_ribbon(aes(x = Year, y = pred, ymin = pred_lwr, ymax = pred_upr, group = 1), fill = "darkred",alpha = 0.2) +
    geom_line(aes(x = Year, y = Cases, color = Country), size = 1) +
    geom_area(aes(x = Year, y = Travel.Cases*100, group = 1), color = "grey50", alpha = 0.4) +
    labs(color = "Reported Local Cases") +
    facet_wrap(~Country, scales = "free") +
    theme_classic() +
    scale_color_carto_d(palette = "Temps") +
    scale_fill_carto_d(palette = "Temps") 
  
  assign(paste0("p_", df_nm, "_ts"), p1, envir = globalenv())
  
  
  #SCATTERPLOT PREDICTED LOCAL VERSE REPORTED
  p2 = ggplot(df) +
    geom_point(aes(x = travel_incidence_dot, y = Cases, color = Country)) +
    geom_line(aes(x = travel_incidence_dot, y = pred, color = Country), size = 1) +
    geom_ribbon(aes(x = travel_incidence_dot, y = pred, 
                    ymin = pred_lwr, ymax = pred_upr, group = 1), 
                fill = "darkred", alpha = 0.3) +
    #labs(color = "Reported Local Cases") +
    facet_wrap(~Country, scales = "free") +
    theme_classic() +
    scale_color_carto_d(palette = "Temps") +
    scale_fill_carto_d(palette = "Temps") 
  
  assign(paste0("p_",df_nm, "_scat"), p2, envir = globalenv())
}