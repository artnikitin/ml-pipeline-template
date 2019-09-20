import os

data_dir = 'static/data'

# raw data source paths
train_features_zip = os.path.join(data_dir, 'train_features.csv.zip')
train_targets_zip = os.path.join(data_dir, 'train_targets.csv.zip')
test_features_zip = os.path.join(data_dir, 'test_features.csv.zip')

test_features_csv = os.path.join(data_dir, 'test_features.csv')
train_features_csv = os.path.join(data_dir, 'train_features.csv')
train_targets_csv = os.path.join(data_dir, 'train_targets.csv')

# outputs of train, test split
X_train = os.path.join(data_dir, 'X_train.pkl')
X_valid = os.path.join(data_dir, 'X_valid.pkl')
y_train = os.path.join(data_dir, 'y_train.pkl')
y_valid = os.path.join(data_dir, 'y_valid.pkl')

# result - output model
model = os.path.join(data_dir, 'model.pkl')

# scores
scores = os.path.join(data_dir, 'eval.json')

