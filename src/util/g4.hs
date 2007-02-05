module G4Wrapper where
import qualified System.Environment
import qualified System.Directory
import qualified IO
import qualified Char
import qualified List
import qualified Text.Regex as Regex
import qualified System.Posix.Env as Env
import qualified System.Directory as Directory
import Control.Monad
import Text.Printf (printf)

main = do
	args <- System.Environment.getArgs
	run_cmd <- case head args of
		"submit" -> maybe_run_grunt (tail args)
		"mail" -> Env.setEnv "P4DIFF" "/bin/true" True >> return True
		_ -> return True
	when run_cmd $
		printf "run %s\n" (show run_cmd)


grunt_cmd = ["grunt", "-c", "--test_retry_limit=0"]
maybe_run_grunt args = do
	let cl = head (dropWhile (/="-c") args)
	dirs <- List.nub `fmap` build_dirs cl
	printf "run tests in %s? " (unwords dirs)
	ask <- IO.hGetChar IO.stdin
	case ask of
		'y' -> do
			rcode <- subprocess_call (grunt_cmd ++ dirs)
			if rcode /= 0
				then printf "tests failed!\n" >> return False
				else return True
		_ -> return False


build_dirs :: String -> IO [String]
build_dirs cl = do
	let stdout = desc_stdout
	let (in_google3, not_google3) = partition_google3 (process_stdout stdout)
	when (not (null not_google3)) $
		fail $ printf "not google3: %s" (show not_google3)
	g3dir <- google3_dir `fmap` System.Directory.getCurrentDirectory
	(mapM (build_dir_of . ((g3dir ++ "/") ++)) . List.nub . map dirname)
		in_google3

dirname = reverse . drop_slash . dropWhile (/='/') . drop_slash . reverse
	where drop_slash s = if head s == '/' then tail s else s

process_stdout = filter (not.blank) . drop 1
	. dropWhile (not . ("Affected files " `List.isPrefixOf`)) . lines
blank = List.all Char.isSpace

partition_google3 fns = either_partition (map match fns)
	where
	match fn = case Regex.matchRegex reg fn of
		Nothing -> Left fn
		(Just ms) -> Right (head ms)
	reg = Regex.mkRegex "//depot/google3/(.*)\\#[0-9]+ "

either_partition xs = (join ls, join rs)
	where
	(ls, rs) = List.partition (either (const True) (const False)) xs
	join = map (either id id)

google3_dir dir
	| null s = "/home/build/google3"
	| otherwise = head s
	where s = dropWhile (not . ("/google3/" `List.isSuffixOf`)) (List.inits dir)

-- walk up path until I find one with a BUILD in it
build_dir_of path = do
	exists <- Directory.doesFileExist (path ++ "/BUILD")
	if exists then return (path ++ "/BUILD")
		else build_dir_of (dirname path)


subprocess_call cmd = return 0

desc_stdout = "\
\Change 3839115 by elaforge@elaforge-local on 2007/01/09 20:28:53 *pending*\
\\
\        - add misc tables that touchpad wants\
\        - for r2 compatibility, swaps must have nullable date, case_id, and\
\        user_name (r3 doesn't use these)\
\\
\        PRESUBMIT=passed\
\        R=ksw,psolodov\
\        OCL=3839115\
\\
\Affected files ...\
\\
\... //depot/google3/ops/hardware/r3/test/generate_unsharded.sh#4 edit\
\... //depot/google3/ops/hardware/r3/test/unsharded_mldb.sql#6 edit\
\  \
\"

