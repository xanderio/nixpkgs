{
  lib,
  rustPlatform,
  versionCheckHook,
  stalwart-mail,
  dasel,
}:

rustPlatform.buildRustPackage {
  inherit (stalwart-mail) src version cargoDeps;
  pname = "stalwart-cli";

  cargoBuildFlags = [
    "--package"
    "stalwart-cli"
  ];
  cargoTestFlags = [
    "--package"
    "stalwart-cli"
  ];

  postPatch = ''
    # upstream forgot to dump this, let's patch this so version check passes
    ${lib.getExe dasel} put -f crates/cli/Cargo.toml -v ${stalwart-mail.version} -s 'package.version'
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "--version" ];

  meta = stalwart-mail.meta // {
    description = "Stalwart Mail Server CLI";
    mainProgram = "stalwart-cli";
    maintainers = with lib.maintainers; [
      giomf
    ];
  };
}
