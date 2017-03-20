insert :: [Int] -> Int -> [Int]

insert [] x     =   [x]
insert (y:l) x
    | x > y     =   (y:insert l x)
    | otherwise =   (x:(y:l))

isort :: [Int] -> [Int]

isort []        =   []
isort (y:l)     =   insert (isort l) y

remove :: [Int] -> Int -> [Int]

remove (y:l) x
    | y == x    =   l
    | otherwise =   (y:remove l x)

ssort :: [Int] -> [Int]

ssort []    =   []
ssort l     =   (x:ssort (remove l x))
    where x = minimum l

merge :: [Int] -> [Int] -> [Int]

merge [] xs     =   xs
merge xs []     =   xs
merge (x:l1) (y:l2)
    | x <= y    = (x:merge l1 (y:l2))
    | otherwise = (y:merge (x:l1) l2)

msort :: [Int] -> [Int]

msort l
    | n <= 1    =   l
    | otherwise =   merge (msort (take n1 l)) (msort (drop n1 l))
    where
        n = length l
        n1 = div n 2

partsort :: Int -> [Int] -> ([Int], [Int])

partsort x []   =   ([],[])
partsort x (i:l)
    | i <= x    =   (i:fst t, snd t)
    | otherwise =   (fst t, i:snd t)
    where t = partsort x l

qsort :: [Int] -> [Int]
qsort []          =   []
qsort (y:l)       =   (qsort (fst t)) ++ [y] ++ (qsort (snd t))
    where t = partsort y l


genPartsort :: Ord a => a -> [a] -> ([a], [a])

genPartsort x []   =   ([],[])
genPartsort x (i:l)
    | i <= x    =   (i:fst t, snd t)
    | otherwise =   (fst t, i:snd t)
    where t = genPartsort x l

genQsort :: Ord a => [a] -> [a]
genQsort []          =   []
genQsort (y:l)       =   (genQsort (fst t)) ++ [y] ++ (genQsort (snd t))
    where t = genPartsort y l

