#!/usr/bin/env python
""" Password strength and validation """

import re
from setuptools import setup, find_packages

version = None
with open('password_strength/__init__.py', 'r') as f:
    for line in f:
        if line.startswith('__version__'):
            version = line.split('=')[1].strip().strip('\'"')
            break

if not version:
    raise RuntimeError('Cannot find version information')

setup(
    name='password_strength',
    version=version,
    author='Mark Vartanyan',
    author_email='kolypto@gmail.com',

    url='https://github.com/kolypto/py-password-strength',
    license='BSD',
    description=__doc__,
    long_description=open('README.md').read(),
    long_description_content_type='text/markdown',
    keywords=['password', 'strength', 'policy', 'security'],

    packages=find_packages(),
    scripts=[],
    entry_points={},

    install_requires=[
        'six',
    ],
    extras_require={
    },
    include_package_data=True,
    

    platforms='any',
    classifiers=[
        # https://pypi.python.org/pypi?%3Aaction=list_classifiers
        'Development Status :: 5 - Production/Stable',
        'Intended Audience :: Developers',
        'Natural Language :: English',
        'Operating System :: OS Independent',
        'Programming Language :: Python :: 2',
        'Programming Language :: Python :: 3',
        'Topic :: Software Development :: Libraries :: Python Modules',
    ],
)