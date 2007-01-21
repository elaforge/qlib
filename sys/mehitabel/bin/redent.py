#!/usr/bin/env python2.3

import sys, re
from local.cmdline import gripe

def main():
	if len(sys.argv) != 3:
		print >>sys.stderr, 'usage: %s indent_from indent_to' %(
			sys.argv[0])
		sys.exit(1)
	indent_from = sys.argv[1]
	indent_to = sys.argv[2]
	lineno = 0
	for line in sys.stdin:
		lineno += 1
		nt, rest = ntabs(line, lineno, indent_from)
		sys.stdout.write(indent_to * nt)
		sys.stdout.write(rest)
	sys.exit(0)

def ntabs(line, lineno, indent):
	s = re.search(r'^([ \t]*)', line).group(1)
	if ' ' in s and '\t' in s:
		gripe('line %d: mixed tabs and indents' % lineno)
	n = count_startswith(line, indent)
	rest = line[len(indent)*n:]
	return n, rest

	# DOTALL to get \n at end of line
	indent, rest =	re.search(r'^([ \t]*)(.*)', line, re.DOTALL).groups()
	if indent:
		if ' ' in indent and '\t' in indent:
			gripe('line %d: mixed tabs and indents' % lineno)
		elif indent[0] == ' ':
			r = len(indent) / indent_spaces
			if len(indent) % indent_spaces:
				gripe('line %d: indent divmod %d == %s' %(lineno,
					indent_spaces, divmod(len(indent), indent_spaces)), None)
				r += 1
		elif indent[0] == '\t':
			r = len(indent)
	else:
		r = 0
	return r, rest

def count_startswith(s, t):
	c = i = 0
	while s.startswith(t, i):
		c += 1
		i += len(t)
	return c

if __name__ == '__main__':
	main()
