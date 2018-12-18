import re

def multireplace(string, replacements):
    """
    Given a string and a replacement map, it returns the replaced string.
    :param str string: string to execute replacements on
    :param dict replacements: replacement dictionary {value to find: value to replace}
    :rtype: str
    """
    # Place longer ones first to keep shorter substrings from matching where the longer ones should take place
    # For instance given the replacements {'ab': 'AB', 'abc': 'ABC'} against the string 'hey abc', it should produce
    # 'hey ABC' and not 'hey ABc'
    substrs = sorted(replacements, key=len, reverse=True)

    # Create a big OR regex that matches any of the substrings to replace
    regexp = re.compile('|'.join(map(re.escape, substrs)))

    # For each match, look up the new string in the replacements
    return regexp.sub(lambda match: replacements[match.group(0)], string)

# Replacements to make
rep = {
    "x1dd": "\\ddot{x}_1",
    "x2dd": "\\ddot{x}_2",
    "y1dd": "\\ddot{y}_1",
    "y2dd": "\\ddot{y}_2",
    "phi1dd": "\\ddot{\\varphi}_1",
    "phi2dd": "\\ddot{\\varphi}_2",
    "phi1d": "\\dot{\\varphi}_1",
    "phi2d": "\\dot{\\varphi}_2",
    "x1d": "\\dot{x}_1",
    "x2d": "\\dot{x}_2",
    "y1d": "\\dot{y}_1",
    "y2d": "\\dot{y}_2",
    "x1": "x_1",
    "x2": "x_2",
    "y1": "y_1",
    "y2": "y_2",
    "phi1": "\\varphi_1",
    "phi2": "\\varphi_2",
    "m1": "m_1",
    "m2": "m_2",
    "I1": "I_1",
    "I2": "I_2",
    "l1": "l_1",
    "l2": "l_2",
    "lm1" : "\\lambda_1",
    "lm2" : "\\lambda_2",
    "lm3" : "\\lambda_3",
    "lm4" : "\\lambda_4",
    "pi" : "\\pi",
    "lm" : "\\lambda",
    #"alpha": "\\alpha",
    "alphad": "\\dot{\\alpha}",
    "alphadd": "\\ddot{\\alpha}",
    "beta": "\\beta",
    "betad": "\\dot{\\beta}",
    "betadd": "\\ddot{\\beta}",
    "gamma": "\\gamma",
    "gammad": "\\dot{\\gamma}",
    "gammadd": "\\ddot{\\gamma}",

    r"\\frac\{(.*?)\}\{2}": r"\\tfrac{1}{2} {\1} ",
    r"\frac{1}{2}": r"\tfrac{1}{2}",
    }
# r"\\frac\{(.*?)\}\{(\d)}": r"\\frac{1}{\2} {\1} ",

# use these three lines to do the replacement
# rep = dict((re.escape(k), v) for k, v in rep.items())
# pattern = re.compile("|".join(rep.keys()))
# text2 = pattern.sub(lambda m: rep[re.escape(m.group(0))], text1)


with open('matlab_latex_strings.txt', 'rt') as f1:
  data = f1.read()

exec(data)

try:
    texts
except NameError:
    texts = []

print('PYTHON OUTPUT - CLEAN STRINGS')

with open('clean_latex_strings.txt', 'wt') as f2:
    for text in texts:
        out = multireplace(text, rep)
        #result = out
        result = re.sub(r"\\frac\{(.*?)\}\{(\d)}", r"\\tfrac{1}{\2} {\1} ", out, 0)

        f2.write(result)
        f2.write('\n')
        f2.write('\n')
        print('========================================')
        print(result)
        print()
