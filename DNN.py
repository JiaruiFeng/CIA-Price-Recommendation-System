import tensorflow.keras.backend as K
from tensorflow.keras.layers import Input,Dense,BatchNormalization,Activation,Conv1D,\
    Flatten,Reshape,Dropout,concatenate,MaxPooling1D,add
from tensorflow.keras import Model
from tensorflow.keras import regularizers

def DNN(input_dim,layer_list,activation="relu",dropout=0.2):
    input=Input((input_dim,))
    for i in range(len(layer_list)):
        if i==0:
            dense=Dense(layer_list[i],activation=activation,
                        kernel_regularizer=regularizers.l2(0.001))(input)
            dense=BatchNormalization()(dense)
            dense=Activation(activation)(dense)
            if dropout>0:
                dense=Dropout(dropout)(dense)
        else:
            dense=Dense(layer_list[i],activation=activation,
                        kernel_regularizer=regularizers.l2(0.001))(dense)
            dense=BatchNormalization()(dense)
            dense=Activation(activation)(dense)
            if dropout>0:
                dense=Dropout(dropout)(dense)
    output=Dense(1)(dense)
    DNN_model=Model(input,output)
    return DNN_model
