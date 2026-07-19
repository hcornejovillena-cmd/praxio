read_market_file <- function(path) {
  ext <- tolower(tools::file_ext(path))
  if (ext %in% c("xlsx", "xls")) {
    if (!requireNamespace("readxl", quietly = TRUE)) {
      stop("Instala readxl para leer archivos Excel.")
    }
    readxl::read_excel(path)
  } else {
    read.csv(path, check.names = FALSE)
  }
}

default_maxdiff_items <- c(
  "Velocidad de entrega", "Variedad de restaurantes", "Precio del delivery",
  "Seguimiento en tiempo real", "Atencion al cliente 24/7",
  "Descuentos y promociones", "Facilidad de uso de la app",
  "Calidad de los alimentos", "Opciones de pago",
  "Resenas verificadas de usuarios", "Programa de puntos / fidelidad",
  "Empaque ecologico"
)

make_maxdiff_demo <- function(items = default_maxdiff_items, n = 80, sets = 12) {
  set.seed(555)
  n_items <- length(items)
  dat <- data.frame(id_encuestado = seq_len(n), version = 1)
  utilities <- rev(seq_len(n_items)) * runif(n_items, 0.8, 1.2)
  design <- lapply(seq_len(sets), function(i) sample(seq_len(n_items), min(4, n_items)))

  for (t in seq_len(sets)) {
    best <- worst <- integer(n)
    for (i in seq_len(n)) {
      set <- design[[t]]
      u <- utilities[set] * runif(length(set), 0.7, 1.3)
      best[i] <- set[which.max(u)]
      worst[i] <- set[which.min(u)]
    }
    dat[[paste0("t", t, "_mejor")]] <- best
    dat[[paste0("t", t, "_peor")]] <- worst
  }
  dat
}

analyze_maxdiff <- function(data, items) {
  n_items <- length(items)
  best_cols <- grep("_mejor$", names(data), value = TRUE)
  worst_cols <- grep("_peor$", names(data), value = TRUE)
  if (!length(best_cols) || !length(worst_cols)) {
    stop("El archivo debe incluir columnas como t1_mejor, t1_peor, t2_mejor, t2_peor.")
  }

  best <- suppressWarnings(as.integer(unlist(data[best_cols])))
  worst <- suppressWarnings(as.integer(unlist(data[worst_cols])))
  best <- best[!is.na(best) & best >= 1 & best <= n_items]
  worst <- worst[!is.na(worst) & worst >= 1 & worst <= n_items]

  freq_best <- tabulate(best, nbins = n_items)
  freq_worst <- tabulate(worst, nbins = n_items)
  net <- freq_best - freq_worst
  shifted <- net - min(net)
  total <- sum(shifted)
  score <- if (total > 0) round(shifted / total * 100, 1) else rep(round(100 / n_items, 1), n_items)
  score[n_items] <- round(100 - sum(score[-n_items]), 1)

  out <- data.frame(
    item = items,
    mas = freq_best,
    menos = freq_worst,
    neto = net,
    importancia = score
  )
  out <- out[order(-out$neto), ]
  out$rank <- seq_len(nrow(out))
  out[, c("rank", "item", "mas", "menos", "neto", "importancia")]
}

make_vw_demo <- function(n = 120, nms = FALSE) {
  set.seed(if (nms) 888 else 777)
  ref <- 20 + floor(runif(n) * 30)
  muy_barato <- pmax(1, round(ref * runif(n, 0.3, 0.5)))
  barato <- round(ref * runif(n, 0.6, 0.8))
  caro <- round(ref * runif(n, 1.1, 1.4))
  muy_caro <- round(ref * runif(n, 1.4, 1.8))

  dat <- data.frame(
    id = seq_len(n),
    muy_barato = muy_barato,
    barato = pmax(muy_barato, barato),
    caro = pmax(barato, caro),
    muy_caro = pmax(caro, muy_caro)
  )
  if (nms) {
    dat$intent_barato <- pmin(5, pmax(1, round(3 + runif(n) * 2)))
    dat$intent_caro <- pmin(5, pmax(1, round(2 + runif(n) * 2)))
  }
  dat
}

validate_vw_data <- function(data, nms = FALSE) {
  needed <- c("muy_barato", "barato", "caro", "muy_caro")
  if (nms) needed <- c(needed, "intent_barato", "intent_caro")
  missing <- setdiff(needed, names(data))
  if (length(missing)) stop(paste("Faltan columnas:", paste(missing, collapse = ", ")))
  for (col in needed) data[[col]] <- suppressWarnings(as.numeric(data[[col]]))

  valid <- data[
    data$muy_barato > 0 &
      data$barato > 0 &
      data$caro > 0 &
      data$muy_caro > 0 &
      data$muy_barato <= data$barato &
      data$barato <= data$caro &
      data$caro <= data$muy_caro,
  ]
  if (nms) {
    valid <- valid[
      valid$intent_barato >= 1 & valid$intent_barato <= 5 &
        valid$intent_caro >= 1 & valid$intent_caro <= 5,
    ]
  }
  valid
}

intersection <- function(curve, a, b) {
  d <- curve[[a]] - curve[[b]]
  if (nrow(curve) > 1) {
    for (i in seq_len(nrow(curve) - 1)) {
      if (d[i] * d[i + 1] <= 0) {
        p1 <- curve$price[i]
        p2 <- curve$price[i + 1]
        a1 <- curve[[a]][i]
        a2 <- curve[[a]][i + 1]
        b1 <- curve[[b]][i]
        b2 <- curve[[b]][i + 1]
        den <- (a2 - a1) - (b2 - b1)
        t <- if (abs(den) < .Machine$double.eps) 0 else (b1 - a1) / den
        return(data.frame(price = p1 + t * (p2 - p1), pct = a1 + t * (a2 - a1)))
      }
    }
  }
  i <- which.min(abs(d))
  data.frame(price = curve$price[i], pct = curve[[a]][i])
}

analyze_vw <- function(data, nms = FALSE) {
  valid <- validate_vw_data(data, nms)
  if (nrow(valid) < 10) stop(paste("Solo", nrow(valid), "respuestas validas. Se necesitan al menos 10."))

  prices <- sort(unique(unlist(valid[c("muy_barato", "barato", "caro", "muy_caro")])))
  n <- nrow(valid)
  curve <- data.frame(
    price = prices,
    muy_barato = vapply(prices, function(p) mean(valid$muy_barato >= p) * 100, numeric(1)),
    barato = vapply(prices, function(p) mean(valid$barato >= p) * 100, numeric(1)),
    caro = vapply(prices, function(p) mean(valid$caro <= p) * 100, numeric(1)),
    muy_caro = vapply(prices, function(p) mean(valid$muy_caro <= p) * 100, numeric(1))
  )

  points <- data.frame(
    punto = c("PMC", "OPP", "IPP", "PME"),
    descripcion = c("Precio minimo aceptable", "Precio optimo", "Precio de indiferencia", "Precio maximo aceptable"),
    rbind(
      intersection(curve, "muy_barato", "caro"),
      intersection(curve, "muy_barato", "muy_caro"),
      intersection(curve, "barato", "caro"),
      intersection(curve, "barato", "muy_caro")
    )
  )

  stats <- do.call(rbind, lapply(c("muy_barato", "barato", "caro", "muy_caro"), function(col) {
    vals <- valid[[col]]
    data.frame(pregunta = col, media = mean(vals), mediana = median(vals), de = sd(vals), min = min(vals), max = max(vals))
  }))

  list(curve = curve, points = points, stats = stats, valid = valid, excluded = nrow(data) - nrow(valid))
}

analyze_nms <- function(data) {
  res <- analyze_vw(data, nms = TRUE)
  valid <- res$valid
  cal <- c("1" = 0, "2" = 0.10, "3" = 0.30, "4" = 0.50, "5" = 0.70)
  prices <- seq(min(valid$muy_barato), max(valid$muy_caro), by = max(1, round(diff(range(valid$muy_caro, valid$muy_barato)) / 60)))

  demand <- vapply(prices, function(p) {
    probs <- mapply(function(mb, b, c, mc, ib, ic) {
      pb <- cal[as.character(round(ib))]
      pc <- cal[as.character(round(ic))]
      prob <- if (p <= mb) 0 else if (p <= b) {
        pb * (p - mb) / max(b - mb, 1)
      } else if (p <= c) {
        pb + (pc - pb) * (p - b) / max(c - b, 1)
      } else if (p <= mc) {
        pc * (1 - (p - c) / max(mc - c, 1))
      } else 0
      max(0, min(1, prob))
    }, valid$muy_barato, valid$barato, valid$caro, valid$muy_caro, valid$intent_barato, valid$intent_caro)
    mean(probs) * 100
  }, numeric(1))

  res$nms_curve <- data.frame(price = prices, demanda_pct = demand)
  res$nms_curve$revenue_indice <- res$nms_curve$price * res$nms_curve$demanda_pct
  res$max_trial <- res$nms_curve[which.max(res$nms_curve$demanda_pct), ]
  res$max_revenue <- res$nms_curve[which.max(res$nms_curve$revenue_indice), ]
  res
}
