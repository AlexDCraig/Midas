import os

project_id = os.environ['PROJECT_ID']
base_string = 'gcr.io/{}'.format(project_id)
old_midas_data = 'midas-data:v0'
midas_data = '{}/{}'.format(base_string, old_midas_data)
old_midas_web = 'midas-web:v0'
midas_web = '{}/{}'.format(base_string, old_midas_web)
base_filepath = os.path.expanduser("~/Midas/deployments")
midas_data_filepath = '{}/midas-data-deployment.yaml'.format(base_filepath)
midas_web_filepath = '{}/midas-web-deployment.yaml'.format(base_filepath)

def replace_strings_in_deployment(filepath, old_string, new_string):
    amended_text = None

    with open(filepath, "r") as f:
        amended_text = f.read().replace(old_string, new_string).replace('imagePullPolicy: Never', 'imagePullPolicy: Always')

    with open(filepath, "w") as f:
        f.write(amended_text)

def prep_for_gke():
    replace_strings_in_deployment(midas_data_filepath, old_midas_data, midas_data)
    replace_strings_in_deployment(midas_web_filepath, old_midas_web, midas_web)

prep_for_gke()

