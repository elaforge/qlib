'''format tracebacks how I like it

envars:
qtraceback_truncate=int
qtraceback_path_strip=bool

'''

import sys, os, traceback, linecache
import local.hack, local.text
import pdb

def format_exception(typ, val, tb, limit=None):
	if tb:
		r = ['Traceback (most recent call last): ' + '-'*7 + '\n']
		r += format_list(extract_tb(tb, limit))
	else:
		r = []
	r += traceback.format_exception_only(typ, val)
	return r

def format_list(extracted_list):
	r = []
	truncate = os.environ.get('qtraceback_truncate', 16)
	try:
		truncate = int(truncate)
	except ValueError:
		truncate = 0
	for fn, lineno, name, line, fargs in extracted_list:
		args = []
		selfarg = None
		for k, v in fargs:
			if k == 'self':
				selfarg = v
			else:
				v = local.hack.safe_repr(v)
				if truncate:
					v = local.text.truncate(v, truncate, '..')
				args.append('%s=%s' %(k, v))
		if os.environ.get('qtraceback_path_strip'):
			fn = os.path.basename(fn)
		s = '%s:%d in ' %(fn, lineno)
		if selfarg is not None:
			s += '%s.' % selfarg.__class__.__name__
		s += '%s(%s)\n' %(name, ', '.join(args))
		if line:
			s += '\t%s\n' % local.text.truncate(line, 70, '..')
		r.append(s)
	return r

# traceback is badly factored and I have to replace essentially everything
# how does code like this make it to the stdlib?
def _print(fp, s='', terminator='\n'):
	fp.write(s + terminator)
def print_list(extracted_list, file=None):
	if file is None:
		file = sys.stderr
	_print(file, ''.join(format_list(extracted_list)))
def print_exception(typ, val, tb, limit=None, file=None):
	if file is None:
		file = sys.stderr
	_print(file, ''.join(format_exception(typ, val, tb)))

def format_exception_only(etype, value):
	list = []
	if type(etype) == types.ClassType:
		stype = etype.__name__
	else:
		stype = etype
	if value is None:
		list.append(str(stype) + '\n')
	else:
		if etype is SyntaxError:
			try:
				msg, (filename, lineno, offset, line) = value
			except:
				pass
			else:
				if not filename: filename = "<string>"
				list.append('%s:%d\n' % (filename, lineno))
				if line is not None:
					i = 0
					while i < len(line) and line[i].isspace():
						i = i+1
					list.append('	 %s\n' % line.strip())
					if offset is not None:
						s = '	 '
						for c in line[i:offset-1]:
							if c.isspace():
								s = s + c
							else:
								s = s + ' '
						list.append('%s^\n' % s)
					value = msg
		s = _some_str(value)
		if s:
			list.append('%s: %s\n' % (str(stype), s))
		else:
			list.append('%s\n' % str(stype))
	return list

def extract_tb(tb, limit=None):
	if limit is None:
		if hasattr(sys, 'tracebacklimit'):
			limit = sys.tracebacklimit
	list = []
	n = 0
	while tb is not None and (limit is None or n < limit):
		f = tb.tb_frame
		lineno = tb.tb_lineno
		co = f.f_code
		filename = co.co_filename
		name = co.co_name
		# linecache.checkcache(filename) # old python takes 0 args
		linecache.checkcache()
		line = linecache.getline(filename, lineno)
		if line: line = line.strip()
		else: line = None
		list.append((filename, lineno, name, line, local.hack.get_args(f)))
		tb = tb.tb_next
		n = n+1
	return list

def extract_stack(f=None, limit = None):
	if limit is None:
		if hasattr(sys, 'tracebacklimit'):
			limit = sys.tracebacklimit
	list = []
	n = 0
	while f is not None and (limit is None or n < limit):
		lineno = f.f_lineno
		co = f.f_code
		filename = co.co_filename
		name = co.co_name
		# linecache.checkcache(filename)
		linecache.checkcache()
		line = linecache.getline(filename, lineno)
		if line: line = line.strip()
		else: line = None
		list.append((filename, lineno, name, line, local.hack.get_args(f)))
		f = f.f_back
		n = n+1
	list.reverse()
	return list

class Pdb(pdb.Pdb):
	def format_stack_entry(self, frame_lineno, lprefix=': '):
		import linecache, repr
		frame, lineno = frame_lineno
		filename = self.canonic(frame.f_code.co_filename)
		s = '%s:%r ' % (filename, lineno)
		if frame.f_code.co_name:
			s = s + frame.f_code.co_name
		else:
			s = s + "<lambda>"
		if '__args__' in frame.f_locals:
			args = frame.f_locals['__args__']
		else:
			args = None
		if args:
			s = s + repr.repr(args)
		else:
			s = s + '()' 
		if '__return__' in frame.f_locals:
			rv = frame.f_locals['__return__']
			s = s + '->'
			s = s + repr.repr(rv)
		line = linecache.getline(filename, lineno)
		if line: s = s + lprefix + line.strip()
		return s

def install():
	traceback.print_list = print_list
	traceback.format_list = format_list
	traceback.extract_tb = extract_tb
	traceback.extract_stack = extract_stack
	traceback.print_exception = print_exception
	pdb.Pdb = Pdb
