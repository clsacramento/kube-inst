import yaml
import io
import sys

def read_kubeconfig(filepath):
  with open(filepath, 'r') as f:
    return yaml.load(f)

def merge(d1,d2):
  merged = d1.copy()
  for key,value in d2.items():
    if type(value) is list:
      merged[key] = d1[key] + value
    elif type(value) is dict:
      merged[key] = merge(d1,d2)
    else:
      merged[key] = d1[key]
  return merged
    
def kubeconfig_save(kubeconfig_dict,filepath):
  with io.open(filepath,'w') as f:
    yaml.dump(kubeconfig_dict, f, default_flow_style=False)

sys.argv.pop(0)
kubefile1 = sys.argv.pop(0)
kubefile2 = sys.argv.pop(0)
kubemergedfile = sys.argv.pop(0)

k1 = read_kubeconfig(kubefile1)
k2 = read_kubeconfig(kubefile2)
merged = merge(k1,k2)
kubeconfig_save(merged,kubemergedfile)
