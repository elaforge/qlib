module Cmt where
import qualified List
import qualified Char
import qualified System.Exit
import qualified System.Environment

import IO

usage = "usage: cmt cmt_char"

main = do
	args <- System.Environment.getArgs
	case args of
		[cmt] -> interact (string_cmt (cmt ++ " "))
		_ -> do
			putStrLn usage
			System.Exit.exitFailure

string_cmt cmt s = unlines $
		pre ++ map (line_cmt indent cmt) lines'' ++ post
	where
	slines = lines s
	(pre, lines') = break (not.blank_line) slines
	(post, lines'') = app_snd reverse $ break (not.blank_line) (reverse lines')
	indent = indent_of lines''

app_snd f (a, b) = (a, f b)

line_cmt indent cmt line
	-- | blank_line line = ""
	| otherwise = indent ++ cmt ++ post
	where (pre, post) = splitAt (length indent) line

{-
indent_of lines = minimum [length (takeWhile Char.isSpace line)
	| line <- lines, not (blank_line line)]
-}

{-
  foo
 bar
 
  baz
-}
indent_of = head . List.sortBy (\a b -> compare (length a) (length b))
	. map (takeWhile Char.isSpace) . filter (not.blank_line)

blank_line = List.all Char.isSpace

s = "  foo\n bar\n \n  baz\n"

slines = lines s
(pre, lines') = break (not.blank_line) slines
(post, lines'') = app_snd reverse $ break (not.blank_line) (reverse lines')
indent = indent_of lines''

s' = string_cmt "# " s
