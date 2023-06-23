from pymodelica import compile_fmu

# def compile_fmu():
    # '''Compile the fmu.

    # Returns
    # -------
    # fmupath : str
        # Path to compiled fmu.

    # '''

    # # DEFINE MODEL
    # mopath = 'MultiZoneOfficeSimpleAir/package.mo'
    # modelpath = 'MultiZoneOfficeSimpleAir.TestCases.TestCase'

    # # COMPILE FMU
    # fmupath = parser.export_fmu(modelpath, [mopath])

    # return fmupath

if __name__ == "__main__":

    wrapped_path = 'wrapped.mo'
    file_name = 'MultiZoneOfficeSimpleAir/package.mo'
    fmu_path = compile_fmu('wrapped', [wrapped_path]+[file_name], jvm_args="-Xmx8g")
