import importlib.util, json, hashlib
from pathlib import Path
root=Path(r'C:\Coding\NHL-Legacy-Claw')
iso=Path(r'E:\Emulation\roms\xbox360\NHL Legacy Edition (USA, Europe) (En,Fr,De,Sv,Fi,Ru,Cs)\NHL Legacy Edition (USA, Europe) (En,Fr,De,Sv,Fi,Ru,Cs).iso')
out=Path(r'C:\Emulation\NHL-Legacy-Claw\game').resolve()
spec=importlib.util.spec_from_file_location('xdvdfs',root/'source/erik/tools/macos/xdvdfs_extract.py')
m=importlib.util.module_from_spec(spec); spec.loader.exec_module(m)
records=[]
with iso.open('rb') as f:
 base=m.find_base(f); sector,size=m.read_volume(f,base)
 entries=m.walk_dir(f,base,sector,size)
 for name,start,size,isdir in entries:
  target=(out/name).resolve()
  if not target.is_relative_to(out): raise ValueError('Unsafe archive path')
  if not isdir and base+start*m.SECTOR+size>iso.stat().st_size: raise ValueError('Entry exceeds image')
 for name,start,size,isdir in entries:
  if isdir: continue
  target=(out/name).resolve(); target.parent.mkdir(parents=True,exist_ok=True)
  f.seek(base+start*m.SECTOR); remaining=size; digest=hashlib.sha256()
  if target.exists():
   h=hashlib.file_digest(target.open('rb'),'sha256').hexdigest()
   while remaining:
    b=f.read(min(8<<20,remaining))
    if not b: raise EOFError(name)
    digest.update(b); remaining-=len(b)
   if target.stat().st_size!=size or h!=digest.hexdigest(): raise ValueError('Existing file mismatch: '+name)
  else:
   with target.open('xb') as dest:
    while remaining:
     b=f.read(min(8<<20,remaining))
     if not b: raise EOFError(name)
     dest.write(b); digest.update(b); remaining-=len(b)
  records.append(dict(path=name,size=size,sha256=digest.hexdigest()))
  print(name,size,flush=True)
manifest=dict(iso=str(iso),iso_bytes=iso.stat().st_size,partition_base=base,files=records)
(root/'manifests/game-intake.json').write_text(json.dumps(manifest,indent=2))
print('COMPLETE',len(records),sum(x['size'] for x in records),flush=True)
