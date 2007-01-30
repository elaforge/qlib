module Main where
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

string_cmt cmt s = do
	unlines $ map (line_cmt indent cmt) (lines s)
	where indent = indent_of s

line_cmt indent cmt line
	| blank_line line = ""
	| otherwise = pre ++ cmt ++ post
	where (pre, post) = splitAt indent line

indent_of s = minimum [length (takeWhile Char.isSpace line) |
	line <- lines s, not (blank_line line)]

blank_line = List.all Char.isSpace
