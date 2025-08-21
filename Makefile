all:

SHELL := /bin/bash

# Package
.PHONY: clean
clean:
	@rm -rf build/ dist/ *.egg-info/ README.md README.rst
README.md: $(shell find * -type f -name '*.py' -o -name '*.j2') $(wildcard misc/_doc/**)
	@python misc/_doc/README.py | j2 --format=json -o README.md misc/_doc/README.md.j2
README.rst: README.md
	@pandoc -f markdown -t rst -o README.rst README.md

.PHONY: build publish-test publish
build: README.rst
	@./setup.py build sdist bdist_wheel
publish-test: README.rst
	@twine upload --repository pypitest dist/*
publish: README.rst
	@twine upload dist/*


.PHONY: test test-tox test-docker test-docker-2.6
test:
	@nosetests
test-tox:
	@tox
test-docker:
	@docker run --rm -it -v `pwd`:/src themattrix/tox
test-docker-2.6: # temporary, since `themattrix/tox` has faulty 2.6
	@docker run --rm -it -v $(realpath .):/app mrupgrade/deadsnakes:2.6 bash -c 'cd /app && pip install -e . && pip install nose argparse && nosetests'


.PHONY: version
version:
	@echo $(shell python -c 'from password_strength import __version__; print(__version__)')


.PHONY: release
release: release-version release-git release-publish
release-version:
	@read -p "New version: " v; \
	sed -i -E "s/__version__ = '.*'/__version__ = '$$v'/" password_strength/__init__.py
release-git:
	@git commit -a -m "Version $(shell python -c 'from password_strength import __version__; print(__version__)')"; \
	git tag "v$(shell python -c 'from password_strength import __version__; print(__version__)')"
release-publish:
	@./setup.py sdist bdist_wheel
	@twine upload dist/*


.PHONY: bump
bump:
	@read -p "New version: " v; \
	sed -i -E "s/__version__ = '.*'/__version__ = '$$v'/" password_strength/__init__.py; \
	git commit -a -m "Version $$v"; \
	git tag "v$$v"; \
	./setup.py sdist bdist_wheel; \
	twine upload dist/*


.PHONY: bump-git
bump-git:
	@read -p "New version: " v; \
	sed -i -E "s/__version__ = '.*'/__version__ = '$$v'/" password_strength/__init__.py; \
	git commit -a -m "Version $$v"; \
	git tag "v$$v"


.PHONY: bump-publish
bump-publish:
	@./setup.py sdist bdist_wheel
	@twine upload dist/*


.PHONY: bump-patch
bump-patch:
	@v_old=`python -c 'from password_strength import __version__; print(__version__)'`; \
	v_new=`echo $$v_old | awk -F. -v OFS=. '{$3++; print}'`; \
	echo "Bumping version $$v_old -> $$v_new"; \
	sed -i -E "s/__version__ = '.*'/__version__ = '$$v_new'/" password_strength/__init__.py; \
	git commit -a -m "Version $$v_new"; \
	git tag "v$$v_new"; \
	./setup.py sdist bdist_wheel; \
	twine upload dist/*


.PHONY: bump-minor
bump-minor:
	@v_old=`python -c 'from password_strength import __version__; print(__version__)'`; \
	v_new=`echo $$v_old | awk -F. -v OFS=. '{$2++; $3=0; print}'`; \
	echo "Bumping version $$v_old -> $$v_new"; \
	sed -i -E "s/__version__ = '.*'/__version__ = '$$v_new'/" password_strength/__init__.py; \
	git commit -a -m "Version $$v_new"; \
	git tag "v$$v_new"; \
	./setup.py sdist bdist_wheel; \
	twine upload dist/*


.PHONY: bump-major
bump-major:
	@v_old=`python -c 'from password_strength import __version__; print(__version__)'`; \
	v_new=`echo $$v_old | awk -F. -v OFS=. '{$1++; $2=0; $3=0; print}'`; \
	echo "Bumping version $$v_old -> $$v_new"; \
	sed -i -E "s/__version__ = '.*'/__version__ = '$$v_new'/" password_strength/__init__.py; \
	git commit -a -m "Version $$v_new"; \
	git tag "v$$v_new"; \
	./setup.py sdist bdist_wheel; \
	twine upload dist/*