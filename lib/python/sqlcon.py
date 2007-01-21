from google3.ops.hardware.touchpad.dblib import sql_con

local_rw = {
  'host': '127.0.0.1',
  'port': 9201,
  'user': 'mldb_rw',
  'passwd': 'ti4oo-=',
  'db': 'mdb',
}

repl_ro = {
  'host': 'mdbsqlro.prodz.google.com',
  'port': 9200,
  'user': 'mdb_ro',
  'passwd': 'mdb_ro',
  'db': 'mdb',
}

def con(connectd=repl_ro):
  return sql_con.SqlRetry(connectd)
