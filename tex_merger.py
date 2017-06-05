import os

res = os.popen("ls *.tex")
files = res.readlines()
files = map(str.rstrip, files)[::-1]
res.close()

fd = open(files.pop(), 'r')
lines = fd.readlines()
fd.close()

lines_end = lines.index('\\backmatter\n')

while len(files) > 0:
    
    fd = open(files.pop(), 'r')
    chapter_lines = fd.readlines()
    fd.close()
    
    start = chapter_lines.index('\mainmatter\n') + 1
    end = chapter_lines.index('\\backmatter\n')
    
    lines = lines[:lines_end] + chapter_lines[start:end] + lines[lines_end:]
    lines_end = lines.index('\\backmatter\n')

fd = open('book.w', 'w')
fd.writelines(lines)
fd.close()
