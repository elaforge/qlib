module Main where
import qualified List
import qualified System.Exit
import qualified System.Environment

usage = "usage: uncmt cmt_char"

main = do
	args <- System.Environment.getArgs
	case args of
		[cmt] -> interact (string_uncmt cmt)
		_ -> do
			putStrLn usage
			System.Exit.exitFailure

string_uncmt cmt s = unlines $ map (line_uncmt cmt) (lines s)

line_uncmt cmt line = pre ++ post'
	where
	(pre, cmts) = break_tails (cmt `List.isPrefixOf`) line
	post = drop (length cmt) cmts
	post' = if (not (null post) && head post == ' ') then tail post else post

break_tails f seq = head $ dropWhile
	(\(pre, post) -> not (null post || f post))
	(zip (List.inits seq) (List.tails seq))

ts = "hi there\n  # foo bar\n  # baz faz\n# wuz fuz\nboo\n"
