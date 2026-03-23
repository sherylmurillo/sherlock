type Hora = Int

data Estudiante = Estudiante
  { idEst :: String
  , entrada :: Hora
  , salida :: Maybe Hora
  } deriving (Show, Read)

-- Leer archivo
leerArchivo :: IO [Estudiante]
leerArchivo = do
  contenido <- readFile "universidad.txt"
  return (read contenido)

-- Guardar archivo
guardarArchivo :: [Estudiante] -> IO ()
guardarArchivo lista = do
  writeFile "universidad.txt" (show lista)

-- Check In
checkIn :: [Estudiante] -> IO [Estudiante]
checkIn lista = do
  putStrLn "Ingrese ID:"
  id <- getLine
  putStrLn "Hora entrada (minutos):"
  h <- getLine
  let nuevo = Estudiante id (read h) Nothing
  let nuevaLista = nuevo : lista
  guardarArchivo nuevaLista
  return nuevaLista

-- Mostrar estudiantes
mostrar :: [Estudiante] -> IO ()
mostrar lista = mapM_ print lista

-- Buscar estudiante
buscar :: [Estudiante] -> IO ()
buscar lista = do
  putStrLn "Ingrese ID a buscar:"
  id <- getLine
  let encontrados = filter (\e -> idEst e == id && salida e == Nothing) lista
  if null encontrados
    then putStrLn "No encontrado o ya salió"
    else mapM_ print encontrados

-- Check Out
checkOut :: [Estudiante] -> IO [Estudiante]
checkOut lista = do
  putStrLn "Ingrese ID:"
  id <- getLine
  putStrLn "Hora salida (minutos):"
  h <- getLine
  let nuevaLista = map (actualizar id (read h)) lista
  guardarArchivo nuevaLista
  return nuevaLista

actualizar :: String -> Hora -> Estudiante -> Estudiante
actualizar id h e =
  if idEst e == id && salida e == Nothing
    then e { salida = Just h }
    else e

-- Calcular tiempo
calcularTiempo :: Estudiante -> String
calcularTiempo e =
  case salida e of
    Nothing -> "Aún no ha salido"
    Just s -> "Tiempo: " ++ show (s - entrada e) ++ " minutos"

-- Mostrar con tiempo
mostrarConTiempo :: [Estudiante] -> IO ()
mostrarConTiempo lista =
  mapM_ (\e -> print e >> putStrLn (calcularTiempo e)) lista

-- Menú
menu :: [Estudiante] -> IO ()
menu lista = do
  putStrLn "\n1. Check In"
  putStrLn "2. Mostrar"
  putStrLn "3. Buscar"
  putStrLn "4. Check Out"
  putStrLn "5. Mostrar con tiempo"
  putStrLn "6. Salir"
  op <- getLine

  case op of
    "1" -> do
      nueva <- checkIn lista
      menu nueva

    "2" -> do
      mostrar lista
      menu lista

    "3" -> do
      buscar lista
      menu lista

    "4" -> do
      nueva <- checkOut lista
      menu nueva

    "5" -> do
      mostrarConTiempo lista
      menu lista

    "6" -> putStrLn "Pico y chao bb"

    _ -> menu lista

-- Main
main :: IO ()
main = do
  putStrLn "Sistema de estudiantes"
  lista <- leerArchivo
  menu lista
[Estudiante {idEst = "101", entrada = 100, salida = Just 150}]
