
out = open('book.w', 'w')

def rec(file):
    f = open(file, 'r')
    
    for line in f:
        if '\\input{' in line:
            s = line.find('{')
            e = line.find('}')
            rec(line[s+1:e])
        else:
            out.write(line)

    f.close()

rec('book.tex')

out.close()
