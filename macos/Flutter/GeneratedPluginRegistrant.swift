//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import file_chooser
import path_provider_macos
import ssh_plugin

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  FileChooserPlugin.register(with: registry.registrar(forPlugin: "FileChooserPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  SshPlugin.register(with: registry.registrar(forPlugin: "SshPlugin"))
}
