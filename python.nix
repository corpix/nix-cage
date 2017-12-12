with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "devcage-python-shell";
  buildInputs = with python36Packages; [
    geopandas
    jupyter
    jupyterlab
    jupyter_client
    jupyter_console
    jupyter_core
    matplotlib
    numpy
    numpy-stl
    numpydoc
    pandas
    scipy
    scikitlearn
    Keras
    h5py
  ];
}
