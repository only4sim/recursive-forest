import pandas as pd
import numpy as np
import functions as fn
# from functions import load_xgb_model
import xgboost as xgb
from xgboost import plot_tree
import matplotlib.pyplot as plt

model_path = '../models/'
path = '../processed/'
sfx = '_final_subm'

bst1 = fn.load_xgb_model(model_path+'bst1_1'+sfx)
bst1.save_model('bst1.json')
plot_tree(bst1)
plt.show()
plt.savefig('bst1.png')

bst2 = fn.load_xgb_model(model_path+'bst2_1'+sfx)
bst1.save_model('bst2.json')
plot_tree(bst2)
plt.show()
plt.savefig('bst2.png')

bst3 = fn.load_xgb_model(model_path+'bst3_1'+sfx)
bst1.save_model('bst3.json')
plot_tree(bst3)
plt.show()
plt.savefig('bst3.png')

bst4 = fn.load_xgb_model(model_path+'bst4_1'+sfx)
bst1.save_model('bst4.json')
plot_tree(bst4)
plt.show()
plt.savefig('bst4.png')

bst5 = fn.load_xgb_model(model_path+'bst5_1'+sfx)
bst1.save_model('bst5.json')
plot_tree(bst5)
plt.show()
plt.savefig('bst5.png')