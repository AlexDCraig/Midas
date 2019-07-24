import os

old_midas_web = 'midas-web:v0'
midas_web = 'alexdchoffer/{}'.format(old_midas_web)
base_filepath = os.path.expanduser("~/Midas/cloud/gcp/Midas/deployments")
midas_web_filepath = '{}/midas-web-deployment.yaml'.format(base_filepath)

def replace_strings_in_deployment(filepath, old_string, new_string):
    amended_text = None

    with open(filepath, "r") as f:
        amended_text = f.read().replace(old_string, new_string).replace('imagePullPolicy: Never', 'imagePullPolicy: Always')

    with open(filepath, "w") as f:
        f.write(amended_text)

def prep_for_gke():
    replace_strings_in_deployment(midas_web_filepath, old_midas_web, midas_web)

prep_for_gke()

