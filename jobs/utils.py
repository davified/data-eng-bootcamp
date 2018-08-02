def get_absolute_path_of(relative_filepath):
    import os
    project_dir_name = 'twsg-data-eng-bootcamp'
    project_root_dir = os.getcwd().split(project_dir_name)[0] + project_dir_name
    return "{}/{}".format(project_root_dir, relative_filepath)

