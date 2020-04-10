import numpy as np

def mse(y_pre,y_tr):
    original_y_pre=np.exp(y_pre)-1
    num_sample=y_pre.shape[0]
    mse_result=np.sum(np.square(original_y_pre-y_tr))/num_sample
    return mse_result

def rmsle(y_pre,y_tr):
    nat_y_tr=np.log(y_tr+1)
    num_sample=y_pre.shape[0]
    rmsle_result=np.sqrt(np.sum(np.square(y_pre-nat_y_tr))/num_sample)
    return rmsle_result