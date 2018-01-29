# -*- coding:utf-8 -*-

import os
import sys
import glob
from datetime import date
import re

def folder_abs_path(path):
    for char_ind in range(len(path)):
        if path[char_ind] == '/':
            last_slash_index = char_ind

    return(path[:last_slash_index+1])

def render_unlock_file(html_file):

    folder_path = folder_abs_path(html_file)

    html_file = open(html_file, 'rU')
    output_file = open(folder_path + 'output.html', 'w')

    scripts = []
    for line in html_file.readlines():
        if re.search("\/rmarkdown-libs\/.*", line) != None:
            scripts.append(line)
            continue
        if re.search("<\/body>", line) != None:
            for script in scripts:
                output_file.write(script)
        output_file.write(line)
    
    os.remove(folder_path + 'index.html')
    os.rename(folder_path + 'output.html', folder_path + 'index.html')

def main():
    html_files = glob.glob(os.getcwd() + '/docs/201*/**/*.html', recursive=True)
    for i in html_files:
        render_unlock_file(i)
        print("Finished unlocking\n" + i)

if __name__ == "__main__":
    main()
