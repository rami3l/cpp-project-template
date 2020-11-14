.PHONY: run clean

run: 
	# Usage: `make run ARGS="--help"`
	cmake -Bbuild -H. -DCMAKE_BUILD_TYPE=Debug -DARGS=${ARGS}
	cmake --build build --target run 

debug:
	cmake -Bbuild -H. -DCMAKE_BUILD_TYPE=Debug
	cmake --build build --target

release:
	cmake -Bbuild -H. -DCMAKE_BUILD_TYPE=Release
	cmake --build build --target

clean:
	rm -rfv ./build 

test:
	python3 test_script.py
