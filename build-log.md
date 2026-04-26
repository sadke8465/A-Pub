
Showing Recent Messages
Resolving package dependencies…
x-xcode-log://05F8BD21-533D-45F7-8122-BD6DC0186429: Failed to resolve package dependencies


Prepare build

ComputePackagePrebuildTargetDependencyGraph

CreateBuildRequest

SendProjectDescription

CreateBuildOperation

ComputeTargetDependencyGraph

note: Building targets in dependency order
note: Target dependency graph (8 targets)
    Target 'EpubReader' in project 'EpubReader'
        ➜ Explicit dependency on target 'ZIPFoundation' in project 'ZIPFoundation'
        ➜ Explicit dependency on target 'GRDB' in project 'GRDB'
    Target 'GRDB' in project 'GRDB'
        ➜ Explicit dependency on target 'GRDB' in project 'GRDB'
        ➜ Explicit dependency on target 'GRDB_GRDB' in project 'GRDB'
    Target 'GRDB' in project 'GRDB'
        ➜ Explicit dependency on target 'GRDB_GRDB' in project 'GRDB'
        ➜ Explicit dependency on target 'GRDBSQLite' in project 'GRDB'
    Target 'GRDBSQLite' in project 'GRDB' (no dependencies)
    Target 'GRDB_GRDB' in project 'GRDB' (no dependencies)
    Target 'ZIPFoundation' in project 'ZIPFoundation'
        ➜ Explicit dependency on target 'ZIPFoundation' in project 'ZIPFoundation'
        ➜ Explicit dependency on target 'ZIPFoundation_ZIPFoundation' in project 'ZIPFoundation'
    Target 'ZIPFoundation' in project 'ZIPFoundation'
        ➜ Explicit dependency on target 'ZIPFoundation_ZIPFoundation' in project 'ZIPFoundation'
    Target 'ZIPFoundation_ZIPFoundation' in project 'ZIPFoundation' (no dependencies)

Building targets in dependency order

Target dependency graph (8 targets)

GatherProvisioningInputs

CreateBuildDescription

Build description signature: 0611f56052317d0548c9779852d46841
Build description path: /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/XCBuildData/0611f56052317d0548c9779852d46841.xcbuilddata

ExecuteExternalTool /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -v -E -dM -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk -x c -c /dev/null

ExecuteExternalTool /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swiftc --version

ExecuteExternalTool /Applications/Xcode.app/Contents/Developer/usr/bin/momc --dry-run --action generate --swift-version 6.0 --sdkroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk --iphonesimulator-deployment-target 17.0 --module EpubReader /Users/noamsadi/A-Pub/EpubReader/EpubReader.xcdatamodeld /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader

ExecuteExternalTool /Applications/Xcode.app/Contents/Developer/usr/bin/actool --print-asset-tag-combinations --output-format xml1 /Users/noamsadi/A-Pub/EpubReader/Preview Content/Preview Assets.xcassets /Users/noamsadi/A-Pub/EpubReader/Assets.xcassets

ExecuteExternalTool /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld -version_details

ReadFileContents /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/share/docc/features.json

ExecuteExternalTool /Applications/Xcode.app/Contents/Developer/usr/bin/actool --version --output-format xml1

ClangStatCache /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang-stat-cache /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk /Users/noamsadi/Library/Developer/Xcode/DerivedData/SDKStatCaches.noindex/iphonesimulator26.1-23B77-3885c01c3e6b6a337905948deab2002e90cf18a4295e390e64c810bc6bd7acbc.sdkstatcache
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang-stat-cache /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk -o /Users/noamsadi/Library/Developer/Xcode/DerivedData/SDKStatCaches.noindex/iphonesimulator26.1-23B77-3885c01c3e6b6a337905948deab2002e90cf18a4295e390e64c810bc6bd7acbc.sdkstatcache

CreateBuildDirectory /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    builtin-create-build-directory /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products

CreateBuildDirectory /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    builtin-create-build-directory /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex

CreateBuildDirectory /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    builtin-create-build-directory /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator

CreateBuildDirectory /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ExplicitPrecompiledModules
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    builtin-create-build-directory /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ExplicitPrecompiledModules

CreateBuildDirectory /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/SwiftExplicitPrecompiledModules
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    builtin-create-build-directory /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/SwiftExplicitPrecompiledModules

CreateBuildDirectory /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EagerLinkingTBDs/Debug-iphonesimulator
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    builtin-create-build-directory /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EagerLinkingTBDs/Debug-iphonesimulator

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader-4d5c3879ad9b5d9dced6c7c32c3b37ba-VFS-iphonesimulator/all-product-headers.yaml
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader-4d5c3879ad9b5d9dced6c7c32c3b37ba-VFS-iphonesimulator/all-product-headers.yaml

CreateBuildDirectory /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/PackageFrameworks
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    builtin-create-build-directory /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/PackageFrameworks

SwiftExplicitDependencyGeneratePcm arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/SwiftExplicitPrecompiledModules/GRDBSQLite-DH2SGJZUFAI7S2CVXIQ7VZR6V.pcm


Build target ZIPFoundation_ZIPFoundation with configuration Debug

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation_ZIPFoundation.build/empty-ZIPFoundation_ZIPFoundation.plist (in target 'ZIPFoundation_ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation_ZIPFoundation.build/empty-ZIPFoundation_ZIPFoundation.plist

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation_ZIPFoundation.build/ZIPFoundation_ZIPFoundation.DependencyMetadataFileList (in target 'ZIPFoundation_ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation_ZIPFoundation.build/ZIPFoundation_ZIPFoundation.DependencyMetadataFileList

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation_ZIPFoundation.build/ZIPFoundation_ZIPFoundation.DependencyStaticMetadataFileList (in target 'ZIPFoundation_ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation_ZIPFoundation.build/ZIPFoundation_ZIPFoundation.DependencyStaticMetadataFileList

MkDir /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/ZIPFoundation_ZIPFoundation.bundle (in target 'ZIPFoundation_ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation
    /bin/mkdir -p /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/ZIPFoundation_ZIPFoundation.bundle

ProcessInfoPlistFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/ZIPFoundation_ZIPFoundation.bundle/Info.plist /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation_ZIPFoundation.build/empty-ZIPFoundation_ZIPFoundation.plist (in target 'ZIPFoundation_ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation
    builtin-infoPlistUtility /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation_ZIPFoundation.build/empty-ZIPFoundation_ZIPFoundation.plist -producttype com.apple.product-type.bundle -expandbuildsettings -format binary -platform iphonesimulator -o /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/ZIPFoundation_ZIPFoundation.bundle/Info.plist

CpResource /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/ZIPFoundation_ZIPFoundation.bundle/PrivacyInfo.xcprivacy /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Resources/PrivacyInfo.xcprivacy (in target 'ZIPFoundation_ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation
    builtin-copy -exclude .DS_Store -exclude CVS -exclude .svn -exclude .git -exclude .hg -resolve-src-symlinks /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Resources/PrivacyInfo.xcprivacy /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/ZIPFoundation_ZIPFoundation.bundle

CodeSign /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/ZIPFoundation_ZIPFoundation.bundle (in target 'ZIPFoundation_ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation
    
    Signing Identity:     "Sign to Run Locally"
    
    /usr/bin/codesign --force --sign - --timestamp\=none --generate-entitlement-der /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/ZIPFoundation_ZIPFoundation.bundle

RegisterExecutionPolicyException /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/ZIPFoundation_ZIPFoundation.bundle (in target 'ZIPFoundation_ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation
    builtin-RegisterExecutionPolicyException /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/ZIPFoundation_ZIPFoundation.bundle

Touch /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/ZIPFoundation_ZIPFoundation.bundle (in target 'ZIPFoundation_ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation
    /usr/bin/touch -c /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/ZIPFoundation_ZIPFoundation.bundle


Build target ZIPFoundation with configuration Debug

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/ZIPFoundation.DependencyStaticMetadataFileList (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/ZIPFoundation.DependencyStaticMetadataFileList

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/ZIPFoundation.modulemap (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/ZIPFoundation.modulemap

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/ZIPFoundation.DependencyMetadataFileList (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/ZIPFoundation.DependencyMetadataFileList

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation_const_extract_protocols.json (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation_const_extract_protocols.json

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation.SwiftFileList (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation.SwiftFileList

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation.SwiftConstValuesFileList (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation.SwiftConstValuesFileList

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation.LinkFileList (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation.LinkFileList

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation-OutputFileMap.json (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation-OutputFileMap.json

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/DerivedSources/resource_bundle_accessor.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/DerivedSources/resource_bundle_accessor.swift

Copy /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GeneratedModuleMaps-iphonesimulator/ZIPFoundation.modulemap /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/ZIPFoundation.modulemap (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation
    builtin-copy -exclude .DS_Store -exclude CVS -exclude .svn -exclude .git -exclude .hg -resolve-src-symlinks /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/ZIPFoundation.modulemap /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GeneratedModuleMaps-iphonesimulator

SwiftDriver ZIPFoundation normal arm64 com.apple.xcode.tools.swift.compiler (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    builtin-SwiftDriver -- /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swiftc -module-name ZIPFoundation -Onone -enforce-exclusivity\=checked @/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation.SwiftFileList -DSWIFT_PACKAGE -DDEBUG -DSWIFT_MODULE_RESOURCE_BUNDLE_AVAILABLE -DXcode -plugin-path /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/host/plugins/testing -enable-experimental-feature DebugDescriptionMacro -sdk /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk -target arm64-apple-ios12.0-simulator -g -module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex -Xfrontend -serialize-debugging-options -enable-testing -suppress-warnings -index-store-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Index.noindex/DataStore -Xcc -D_LIBCPP_HARDENING_MODE\=_LIBCPP_HARDENING_MODE_DEBUG -swift-version 5 -I /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator -Isystem /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/usr/lib -F /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator -F /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Library/Frameworks -F /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk/Developer/Library/Frameworks -c -j8 -enable-batch-mode -incremental -Xcc -ivfsstatcache -Xcc /Users/noamsadi/Library/Developer/Xcode/DerivedData/SDKStatCaches.noindex/iphonesimulator26.1-23B77-3885c01c3e6b6a337905948deab2002e90cf18a4295e390e64c810bc6bd7acbc.sdkstatcache -output-file-map /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation-OutputFileMap.json -use-frontend-parseable-output -save-temps -no-color-diagnostics -explicit-module-build -module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/SwiftExplicitPrecompiledModules -clang-scanner-module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex -sdk-module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex -serialize-diagnostics -emit-dependencies -emit-module -emit-module-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation.swiftmodule -validate-clang-modules-once -clang-build-session-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Session.modulevalidation -package-name zipfoundation -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/swift-overrides.hmap -emit-const-values -Xfrontend -const-gather-protocols-file -Xfrontend /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation_const_extract_protocols.json -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/include -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/DerivedSources-normal/arm64 -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/DerivedSources/arm64 -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/DerivedSources -Xcc -DSWIFT_PACKAGE -Xcc -DDEBUG\=1 -emit-objc-header -emit-objc-header-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation-Swift.h -working-directory /Users/noamsadi/A-Pub/EpubReader.xcodeproj -experimental-emit-module-separately -disable-cmo

SwiftEmitModule normal arm64 Emitting\ module\ for\ ZIPFoundation (in target 'ZIPFoundation' from project 'ZIPFoundation')

EmitSwiftModule normal arm64 (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 Compiling\ resource_bundle_accessor.swift,\ Archive+BackingConfiguration.swift,\ Archive+Deprecated.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/DerivedSources/resource_bundle_accessor.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Archive+BackingConfiguration.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Archive+Deprecated.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/DerivedSources/resource_bundle_accessor.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Archive+BackingConfiguration.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Archive+Deprecated.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 Compiling\ Archive+Helpers.swift,\ Archive+MemoryFile.swift,\ Archive+Progress.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Archive+Helpers.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Archive+MemoryFile.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Archive+Progress.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Archive+Helpers.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Archive+MemoryFile.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Archive+Progress.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 Compiling\ Archive+WritingDeprecated.swift,\ Archive+ZIP64.swift,\ Archive.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Archive+WritingDeprecated.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Archive+ZIP64.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Archive.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Archive+WritingDeprecated.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Archive+ZIP64.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Archive.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 Compiling\ FileManager+ZIPDeprecated.swift,\ URL+ZIP.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/FileManager+ZIPDeprecated.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/URL+ZIP.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/FileManager+ZIPDeprecated.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/URL+ZIP.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 Compiling\ Data+Compression.swift,\ Data+CompressionDeprecated.swift,\ Data+Serialization.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Data+Compression.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Data+CompressionDeprecated.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Data+Serialization.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Data+Compression.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Data+CompressionDeprecated.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Data+Serialization.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 Compiling\ Archive+Reading.swift,\ Archive+ReadingDeprecated.swift,\ Archive+Writing.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Archive+Reading.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Archive+ReadingDeprecated.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Archive+Writing.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Archive+Reading.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Archive+ReadingDeprecated.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Archive+Writing.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 Compiling\ Entry.swift,\ FileManager+ZIP.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Entry.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/FileManager+ZIP.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Entry.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/FileManager+ZIP.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftDriverJobDiscovery normal arm64 Emitting module for ZIPFoundation (in target 'ZIPFoundation' from project 'ZIPFoundation')

SwiftDriver\ Compilation\ Requirements ZIPFoundation normal arm64 com.apple.xcode.tools.swift.compiler (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    builtin-Swift-Compilation-Requirements -- /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swiftc -module-name ZIPFoundation -Onone -enforce-exclusivity\=checked @/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation.SwiftFileList -DSWIFT_PACKAGE -DDEBUG -DSWIFT_MODULE_RESOURCE_BUNDLE_AVAILABLE -DXcode -plugin-path /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/host/plugins/testing -enable-experimental-feature DebugDescriptionMacro -sdk /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk -target arm64-apple-ios12.0-simulator -g -module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex -Xfrontend -serialize-debugging-options -enable-testing -suppress-warnings -index-store-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Index.noindex/DataStore -Xcc -D_LIBCPP_HARDENING_MODE\=_LIBCPP_HARDENING_MODE_DEBUG -swift-version 5 -I /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator -Isystem /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/usr/lib -F /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator -F /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Library/Frameworks -F /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk/Developer/Library/Frameworks -c -j8 -enable-batch-mode -incremental -Xcc -ivfsstatcache -Xcc /Users/noamsadi/Library/Developer/Xcode/DerivedData/SDKStatCaches.noindex/iphonesimulator26.1-23B77-3885c01c3e6b6a337905948deab2002e90cf18a4295e390e64c810bc6bd7acbc.sdkstatcache -output-file-map /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation-OutputFileMap.json -use-frontend-parseable-output -save-temps -no-color-diagnostics -explicit-module-build -module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/SwiftExplicitPrecompiledModules -clang-scanner-module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex -sdk-module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex -serialize-diagnostics -emit-dependencies -emit-module -emit-module-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation.swiftmodule -validate-clang-modules-once -clang-build-session-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Session.modulevalidation -package-name zipfoundation -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/swift-overrides.hmap -emit-const-values -Xfrontend -const-gather-protocols-file -Xfrontend /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation_const_extract_protocols.json -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/include -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/DerivedSources-normal/arm64 -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/DerivedSources/arm64 -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/DerivedSources -Xcc -DSWIFT_PACKAGE -Xcc -DDEBUG\=1 -emit-objc-header -emit-objc-header-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation-Swift.h -working-directory /Users/noamsadi/A-Pub/EpubReader.xcodeproj -experimental-emit-module-separately -disable-cmo

SwiftDriverJobDiscovery normal arm64 Compiling FileManager+ZIPDeprecated.swift, URL+ZIP.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')

SwiftCompile normal arm64 Compiling\ Date+ZIP.swift,\ Entry+Serialization.swift,\ Entry+ZIP64.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Date+ZIP.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Entry+Serialization.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Entry+ZIP64.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Date+ZIP.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Entry+Serialization.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation/Sources/ZIPFoundation/Entry+ZIP64.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftMergeGeneratedHeaders /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GeneratedModuleMaps-iphonesimulator/ZIPFoundation-Swift.h /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation-Swift.h (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation
    builtin-swiftHeaderTool -arch arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation-Swift.h -o /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GeneratedModuleMaps-iphonesimulator/ZIPFoundation-Swift.h

Copy /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/ZIPFoundation.swiftmodule/arm64-apple-ios-simulator.swiftmodule /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation.swiftmodule (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation
    builtin-copy -exclude .DS_Store -exclude CVS -exclude .svn -exclude .git -exclude .hg -resolve-src-symlinks -rename /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation.swiftmodule /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/ZIPFoundation.swiftmodule/arm64-apple-ios-simulator.swiftmodule

Copy /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/ZIPFoundation.swiftmodule/arm64-apple-ios-simulator.swiftdoc /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation.swiftdoc (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation
    builtin-copy -exclude .DS_Store -exclude CVS -exclude .svn -exclude .git -exclude .hg -resolve-src-symlinks -rename /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation.swiftdoc /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/ZIPFoundation.swiftmodule/arm64-apple-ios-simulator.swiftdoc

Copy /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/ZIPFoundation.swiftmodule/arm64-apple-ios-simulator.abi.json /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation.abi.json (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation
    builtin-copy -exclude .DS_Store -exclude CVS -exclude .svn -exclude .git -exclude .hg -resolve-src-symlinks -rename /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation.abi.json /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/ZIPFoundation.swiftmodule/arm64-apple-ios-simulator.abi.json

SwiftDriverJobDiscovery normal arm64 Compiling resource_bundle_accessor.swift, Archive+BackingConfiguration.swift, Archive+Deprecated.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')

Copy /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/ZIPFoundation.swiftmodule/Project/arm64-apple-ios-simulator.swiftsourceinfo /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation.swiftsourceinfo (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation
    builtin-copy -exclude .DS_Store -exclude CVS -exclude .svn -exclude .git -exclude .hg -resolve-src-symlinks -rename /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation.swiftsourceinfo /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/ZIPFoundation.swiftmodule/Project/arm64-apple-ios-simulator.swiftsourceinfo

SwiftDriverJobDiscovery normal arm64 Compiling Data+Compression.swift, Data+CompressionDeprecated.swift, Data+Serialization.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')

SwiftDriverJobDiscovery normal arm64 Compiling Archive+Helpers.swift, Archive+MemoryFile.swift, Archive+Progress.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')

SwiftDriverJobDiscovery normal arm64 Compiling Archive+WritingDeprecated.swift, Archive+ZIP64.swift, Archive.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')

SwiftDriverJobDiscovery normal arm64 Compiling Archive+Reading.swift, Archive+ReadingDeprecated.swift, Archive+Writing.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')

SwiftDriverJobDiscovery normal arm64 Compiling Entry.swift, FileManager+ZIP.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')

SwiftDriverJobDiscovery normal arm64 Compiling Date+ZIP.swift, Entry+Serialization.swift, Entry+ZIP64.swift (in target 'ZIPFoundation' from project 'ZIPFoundation')

SwiftDriver\ Compilation ZIPFoundation normal arm64 com.apple.xcode.tools.swift.compiler (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    builtin-Swift-Compilation -- /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swiftc -module-name ZIPFoundation -Onone -enforce-exclusivity\=checked @/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation.SwiftFileList -DSWIFT_PACKAGE -DDEBUG -DSWIFT_MODULE_RESOURCE_BUNDLE_AVAILABLE -DXcode -plugin-path /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/host/plugins/testing -enable-experimental-feature DebugDescriptionMacro -sdk /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk -target arm64-apple-ios12.0-simulator -g -module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex -Xfrontend -serialize-debugging-options -enable-testing -suppress-warnings -index-store-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Index.noindex/DataStore -Xcc -D_LIBCPP_HARDENING_MODE\=_LIBCPP_HARDENING_MODE_DEBUG -swift-version 5 -I /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator -Isystem /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/usr/lib -F /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator -F /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Library/Frameworks -F /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk/Developer/Library/Frameworks -c -j8 -enable-batch-mode -incremental -Xcc -ivfsstatcache -Xcc /Users/noamsadi/Library/Developer/Xcode/DerivedData/SDKStatCaches.noindex/iphonesimulator26.1-23B77-3885c01c3e6b6a337905948deab2002e90cf18a4295e390e64c810bc6bd7acbc.sdkstatcache -output-file-map /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation-OutputFileMap.json -use-frontend-parseable-output -save-temps -no-color-diagnostics -explicit-module-build -module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/SwiftExplicitPrecompiledModules -clang-scanner-module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex -sdk-module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex -serialize-diagnostics -emit-dependencies -emit-module -emit-module-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation.swiftmodule -validate-clang-modules-once -clang-build-session-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Session.modulevalidation -package-name zipfoundation -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/swift-overrides.hmap -emit-const-values -Xfrontend -const-gather-protocols-file -Xfrontend /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation_const_extract_protocols.json -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/include -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/DerivedSources-normal/arm64 -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/DerivedSources/arm64 -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/DerivedSources -Xcc -DSWIFT_PACKAGE -Xcc -DDEBUG\=1 -emit-objc-header -emit-objc-header-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation-Swift.h -working-directory /Users/noamsadi/A-Pub/EpubReader.xcodeproj -experimental-emit-module-separately -disable-cmo

Ld /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/ZIPFoundation.o normal (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation
    /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -Xlinker -reproducible -target arm64-apple-ios12.0-simulator -r -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk -O0 -w -L/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EagerLinkingTBDs/Debug-iphonesimulator -L/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator -L/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/usr/lib -F/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EagerLinkingTBDs/Debug-iphonesimulator -F/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator -iframework /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Library/Frameworks -iframework /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk/Developer/Library/Frameworks -filelist /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation.LinkFileList -nostdlib -Xlinker -object_path_lto -Xlinker /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation_lto.o -rdynamic -Xlinker -no_deduplicate -Xlinker -objc_abi_version -Xlinker 2 -Xlinker -dependency_info -Xlinker /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation_dependency_info.dat -fobjc-link-runtime -L/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphonesimulator -L/usr/lib/swift -Xlinker -add_ast_path -Xlinker /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation.swiftmodule @/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation-linker-args.resp -o /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/ZIPFoundation.o

ExtractAppIntentsMetadata (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation
    /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/appintentsmetadataprocessor --toolchain-dir /var/run/com.apple.security.cryptexd/mnt/com.apple.MobileAsset.MetalToolchain-v17.2.54.0.B5ESTF/Metal.xctoolchain --module-name ZIPFoundation --sdk-root /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk --xcode-version 17B55 --platform-family iOS --deployment-target 12.0 --bundle-identifier zipfoundation.ZIPFoundation --output /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/ZIPFoundation.appintents --target-triple arm64-apple-ios12.0-simulator --binary-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/ZIPFoundation.o --dependency-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation_dependency_info.dat --stringsdata-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ExtractedAppShortcutsMetadata.stringsdata --source-file-list /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation.SwiftFileList --metadata-file-list /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/ZIPFoundation.DependencyMetadataFileList --static-metadata-file-list /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/ZIPFoundation.DependencyStaticMetadataFileList --swift-const-vals-list /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/ZIPFoundation.build/Debug-iphonesimulator/ZIPFoundation.build/Objects-normal/arm64/ZIPFoundation.SwiftConstValuesFileList --force --compile-time-extraction --deployment-aware-processing --validate-assistant-intents --no-app-shortcuts-localization

2026-04-26 10:43:11.164 appintentsmetadataprocessor[37220:13559797] Starting appintentsmetadataprocessor export
2026-04-26 10:43:11.423 appintentsmetadataprocessor[37220:13559797] Extracted no relevant App Intents symbols, skipping writing output

RegisterExecutionPolicyException /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/ZIPFoundation.o (in target 'ZIPFoundation' from project 'ZIPFoundation')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/ZIPFoundation
    builtin-RegisterExecutionPolicyException /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/ZIPFoundation.o


Build target GRDB_GRDB with configuration Debug

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB_GRDB.build/GRDB_GRDB.DependencyMetadataFileList (in target 'GRDB_GRDB' from project 'GRDB')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB_GRDB.build/GRDB_GRDB.DependencyMetadataFileList

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB_GRDB.build/empty-GRDB_GRDB.plist (in target 'GRDB_GRDB' from project 'GRDB')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB_GRDB.build/empty-GRDB_GRDB.plist

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB_GRDB.build/GRDB_GRDB.DependencyStaticMetadataFileList (in target 'GRDB_GRDB' from project 'GRDB')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB_GRDB.build/GRDB_GRDB.DependencyStaticMetadataFileList

MkDir /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/GRDB_GRDB.bundle (in target 'GRDB_GRDB' from project 'GRDB')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift
    /bin/mkdir -p /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/GRDB_GRDB.bundle

ProcessInfoPlistFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/GRDB_GRDB.bundle/Info.plist /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB_GRDB.build/empty-GRDB_GRDB.plist (in target 'GRDB_GRDB' from project 'GRDB')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift
    builtin-infoPlistUtility /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB_GRDB.build/empty-GRDB_GRDB.plist -producttype com.apple.product-type.bundle -expandbuildsettings -format binary -platform iphonesimulator -o /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/GRDB_GRDB.bundle/Info.plist

CpResource /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/GRDB_GRDB.bundle/PrivacyInfo.xcprivacy /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/PrivacyInfo.xcprivacy (in target 'GRDB_GRDB' from project 'GRDB')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift
    builtin-copy -exclude .DS_Store -exclude CVS -exclude .svn -exclude .git -exclude .hg -resolve-src-symlinks /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/PrivacyInfo.xcprivacy /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/GRDB_GRDB.bundle

CodeSign /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/GRDB_GRDB.bundle (in target 'GRDB_GRDB' from project 'GRDB')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift
    
    Signing Identity:     "Sign to Run Locally"
    
    /usr/bin/codesign --force --sign - --timestamp\=none --generate-entitlement-der /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/GRDB_GRDB.bundle

RegisterExecutionPolicyException /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/GRDB_GRDB.bundle (in target 'GRDB_GRDB' from project 'GRDB')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift
    builtin-RegisterExecutionPolicyException /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/GRDB_GRDB.bundle

Touch /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/GRDB_GRDB.bundle (in target 'GRDB_GRDB' from project 'GRDB')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift
    /usr/bin/touch -c /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/GRDB_GRDB.bundle


Build target GRDB with configuration Debug

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/GRDB.modulemap (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/GRDB.modulemap

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB-OutputFileMap.json (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB-OutputFileMap.json

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB.SwiftFileList (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB.SwiftFileList

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB.LinkFileList (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB.LinkFileList

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB.SwiftConstValuesFileList (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB.SwiftConstValuesFileList

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB_const_extract_protocols.json (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB_const_extract_protocols.json

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/GRDB.DependencyStaticMetadataFileList (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/GRDB.DependencyStaticMetadataFileList

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/GRDB.DependencyMetadataFileList (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/GRDB.DependencyMetadataFileList

Copy /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GeneratedModuleMaps-iphonesimulator/GRDB.modulemap /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/GRDB.modulemap (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift
    builtin-copy -exclude .DS_Store -exclude CVS -exclude .svn -exclude .git -exclude .hg -resolve-src-symlinks /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/GRDB.modulemap /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GeneratedModuleMaps-iphonesimulator

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/DerivedSources/resource_bundle_accessor.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/DerivedSources/resource_bundle_accessor.swift

SwiftDriver GRDB normal arm64 com.apple.xcode.tools.swift.compiler (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    builtin-SwiftDriver -- /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swiftc -module-name GRDB -Onone -enforce-exclusivity\=checked @/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB.SwiftFileList -DSWIFT_PACKAGE -DDEBUG -DSWIFT_MODULE_RESOURCE_BUNDLE_AVAILABLE -DSQLITE_ENABLE_FTS5 -DSQLITE_ENABLE_SNAPSHOT -Xcc -fmodule-map-file\=/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/Sources/GRDBSQLite/module.modulemap -DXcode -plugin-path /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/host/plugins/testing -enable-experimental-feature DebugDescriptionMacro -sdk /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk -target arm64-apple-ios13.0-simulator -g -module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex -Xfrontend -serialize-debugging-options -enable-testing -suppress-warnings -index-store-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Index.noindex/DataStore -Xcc -D_LIBCPP_HARDENING_MODE\=_LIBCPP_HARDENING_MODE_DEBUG -swift-version 6 -I /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator -Isystem /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/usr/lib -F /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator -F /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Library/Frameworks -F /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk/Developer/Library/Frameworks -emit-localized-strings -emit-localized-strings-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64 -c -j8 -enable-batch-mode -incremental -Xcc -ivfsstatcache -Xcc /Users/noamsadi/Library/Developer/Xcode/DerivedData/SDKStatCaches.noindex/iphonesimulator26.1-23B77-3885c01c3e6b6a337905948deab2002e90cf18a4295e390e64c810bc6bd7acbc.sdkstatcache -output-file-map /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB-OutputFileMap.json -use-frontend-parseable-output -save-temps -no-color-diagnostics -explicit-module-build -module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/SwiftExplicitPrecompiledModules -clang-scanner-module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex -sdk-module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex -serialize-diagnostics -emit-dependencies -emit-module -emit-module-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB.swiftmodule -user-module-version 7.10.0 -validate-clang-modules-once -clang-build-session-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Session.modulevalidation -package-name grdb_swift -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/swift-overrides.hmap -emit-const-values -Xfrontend -const-gather-protocols-file -Xfrontend /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB_const_extract_protocols.json -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/include -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/DerivedSources-normal/arm64 -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/DerivedSources/arm64 -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/DerivedSources -Xcc -DSWIFT_PACKAGE -Xcc -DDEBUG\=1 -emit-objc-header -emit-objc-header-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB-Swift.h -working-directory /Users/noamsadi/A-Pub/EpubReader.xcodeproj -experimental-emit-module-separately -disable-cmo

SwiftEmitModule normal arm64 Emitting\ module\ for\ GRDB (in target 'GRDB' from project 'GRDB')

EmitSwiftModule normal arm64 (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 Compiling\ Inflections+English.swift,\ Inflections.swift,\ Mutex.swift,\ OnDemandFuture.swift,\ OrderedDictionary.swift,\ Pool.swift,\ ReadWriteLock.swift,\ ReceiveValuesOn.swift,\ Refinable.swift,\ Utils.swift,\ DatabaseCancellable.swift,\ ValueConcurrentObserver.swift,\ ValueWriteOnlyObserver.swift,\ Fetch.swift,\ Map.swift,\ RemoveDuplicates.swift,\ Trace.swift,\ ValueReducer.swift,\ SharedValueObservation.swift,\ ValueObservation.swift,\ ValueObservationScheduler.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Utils/Inflections+English.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Utils/Inflections.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Utils/Mutex.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Utils/OnDemandFuture.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Utils/OrderedDictionary.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Utils/Pool.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Utils/ReadWriteLock.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Utils/ReceiveValuesOn.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Utils/Refinable.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Utils/Utils.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/ValueObservation/DatabaseCancellable.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/ValueObservation/Observers/ValueConcurrentObserver.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/ValueObservation/Observers/ValueWriteOnlyObserver.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/ValueObservation/Reducers/Fetch.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/ValueObservation/Reducers/Map.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/ValueObservation/Reducers/RemoveDuplicates.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/ValueObservation/Reducers/Trace.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/ValueObservation/Reducers/ValueReducer.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/ValueObservation/SharedValueObservation.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/ValueObservation/ValueObservation.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/ValueObservation/ValueObservationScheduler.swift (in target 'GRDB' from project 'GRDB')

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Utils/Inflections+English.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Utils/Inflections.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Utils/Mutex.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Utils/OnDemandFuture.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Utils/OrderedDictionary.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Utils/Pool.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Utils/ReadWriteLock.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Utils/ReceiveValuesOn.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Utils/Refinable.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Utils/Utils.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/ValueObservation/DatabaseCancellable.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/ValueObservation/Observers/ValueConcurrentObserver.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/ValueObservation/Observers/ValueWriteOnlyObserver.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/ValueObservation/Reducers/Fetch.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/ValueObservation/Reducers/Map.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/ValueObservation/Reducers/RemoveDuplicates.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/ValueObservation/Reducers/Trace.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/ValueObservation/Reducers/ValueReducer.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/ValueObservation/SharedValueObservation.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/ValueObservation/ValueObservation.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/ValueObservation/ValueObservationScheduler.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 Compiling\ DebugDumpFormat.swift,\ JSONDumpFormat.swift,\ LineDumpFormat.swift,\ ListDumpFormat.swift,\ QuoteDumpFormat.swift,\ FTS3.swift,\ FTS3Pattern.swift,\ FTS3TokenizerDescriptor.swift,\ FTS4.swift,\ FTS5.swift,\ FTS5CustomTokenizer.swift,\ FTS5Pattern.swift,\ FTS5Tokenizer.swift,\ FTS5TokenizerDescriptor.swift,\ FTS5WrapperTokenizer.swift,\ Fixits.swift,\ JSONColumn.swift,\ SQLJSONExpressible.swift,\ SQLJSONFunctions.swift,\ DatabaseMigrator.swift,\ Migration.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Dump/DumpFormats/DebugDumpFormat.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Dump/DumpFormats/JSONDumpFormat.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Dump/DumpFormats/LineDumpFormat.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Dump/DumpFormats/ListDumpFormat.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Dump/DumpFormats/QuoteDumpFormat.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/FTS/FTS3.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/FTS/FTS3Pattern.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/FTS/FTS3TokenizerDescriptor.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/FTS/FTS4.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/FTS/FTS5.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/FTS/FTS5CustomTokenizer.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/FTS/FTS5Pattern.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/FTS/FTS5Tokenizer.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/FTS/FTS5TokenizerDescriptor.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/FTS/FTS5WrapperTokenizer.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Fixits.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/JSON/JSONColumn.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/JSON/SQLJSONExpressible.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/JSON/SQLJSONFunctions.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Migration/DatabaseMigrator.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Migration/Migration.swift (in target 'GRDB' from project 'GRDB')

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Dump/DumpFormats/DebugDumpFormat.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Dump/DumpFormats/JSONDumpFormat.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Dump/DumpFormats/LineDumpFormat.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Dump/DumpFormats/ListDumpFormat.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Dump/DumpFormats/QuoteDumpFormat.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/FTS/FTS3.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/FTS/FTS3Pattern.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/FTS/FTS3TokenizerDescriptor.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/FTS/FTS4.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/FTS/FTS5.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/FTS/FTS5CustomTokenizer.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/FTS/FTS5Pattern.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/FTS/FTS5Tokenizer.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/FTS/FTS5TokenizerDescriptor.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/FTS/FTS5WrapperTokenizer.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Fixits.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/JSON/JSONColumn.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/JSON/SQLJSONExpressible.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/JSON/SQLJSONFunctions.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Migration/DatabaseMigrator.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Migration/Migration.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 Compiling\ Decimal.swift,\ NSData.swift,\ NSNull.swift,\ NSNumber.swift,\ NSString.swift,\ SQLiteDateParser.swift,\ URL.swift,\ UUID.swift,\ DatabaseValueConvertible+Decodable.swift,\ DatabaseValueConvertible+Encodable.swift,\ DatabaseValueConvertible+RawRepresentable.swift,\ JSONRequiredEncoder.swift,\ Optional.swift,\ StandardLibrary.swift,\ TransactionClock.swift,\ TransactionObserver.swift,\ WALSnapshot.swift,\ WALSnapshotTransaction.swift,\ Database+Dump.swift,\ DatabaseReader+dump.swift,\ DumpFormat.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/Foundation/Decimal.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/Foundation/NSData.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/Foundation/NSNull.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/Foundation/NSNumber.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/Foundation/NSString.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/Foundation/SQLiteDateParser.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/Foundation/URL.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/Foundation/UUID.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/StandardLibrary/DatabaseValueConvertible+Decodable.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/StandardLibrary/DatabaseValueConvertible+Encodable.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/StandardLibrary/DatabaseValueConvertible+RawRepresentable.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/StandardLibrary/JSONRequiredEncoder.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/StandardLibrary/Optional.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/StandardLibrary/StandardLibrary.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/TransactionClock.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/TransactionObserver.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/WALSnapshot.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/WALSnapshotTransaction.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Dump/Database+Dump.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Dump/DatabaseReader+dump.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Dump/DumpFormat.swift (in target 'GRDB' from project 'GRDB')

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/Foundation/Decimal.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/Foundation/NSData.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/Foundation/NSNull.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/Foundation/NSNumber.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/Foundation/NSString.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/Foundation/SQLiteDateParser.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/Foundation/URL.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/Foundation/UUID.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/StandardLibrary/DatabaseValueConvertible+Decodable.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/StandardLibrary/DatabaseValueConvertible+Encodable.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/StandardLibrary/DatabaseValueConvertible+RawRepresentable.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/StandardLibrary/JSONRequiredEncoder.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/StandardLibrary/Optional.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/StandardLibrary/StandardLibrary.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/TransactionClock.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/TransactionObserver.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/WALSnapshot.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/WALSnapshotTransaction.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Dump/Database+Dump.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Dump/DatabaseReader+dump.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Dump/DumpFormat.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 Compiling\ DatabaseValue.swift,\ DatabaseValueConvertible.swift,\ DatabaseWriter.swift,\ DispatchQueueActor.swift,\ FetchRequest.swift,\ Row.swift,\ RowAdapter.swift,\ RowDecodingError.swift,\ SQL.swift,\ SQLInterpolation.swift,\ SQLRequest.swift,\ SchedulingWatchdog.swift,\ SerializedDatabase.swift,\ Statement.swift,\ StatementAuthorizer.swift,\ StatementColumnConvertible.swift,\ CGFloat.swift,\ Data.swift,\ DatabaseDateComponents.swift,\ DatabaseValueConvertible+ReferenceConvertible.swift,\ Date.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/DatabaseValue.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/DatabaseValueConvertible.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/DatabaseWriter.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/DispatchQueueActor.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/FetchRequest.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Row.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/RowAdapter.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/RowDecodingError.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/SQL.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/SQLInterpolation.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/SQLRequest.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/SchedulingWatchdog.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/SerializedDatabase.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Statement.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/StatementAuthorizer.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/StatementColumnConvertible.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/CoreGraphics/CGFloat.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/Foundation/Data.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/Foundation/DatabaseDateComponents.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/Foundation/DatabaseValueConvertible+ReferenceConvertible.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/Foundation/Date.swift (in target 'GRDB' from project 'GRDB')

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/DatabaseValue.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/DatabaseValueConvertible.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/DatabaseWriter.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/DispatchQueueActor.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/FetchRequest.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Row.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/RowAdapter.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/RowDecodingError.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/SQL.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/SQLInterpolation.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/SQLRequest.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/SchedulingWatchdog.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/SerializedDatabase.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Statement.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/StatementAuthorizer.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/StatementColumnConvertible.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/CoreGraphics/CGFloat.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/Foundation/Data.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/Foundation/DatabaseDateComponents.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/Foundation/DatabaseValueConvertible+ReferenceConvertible.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Support/Foundation/Date.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 Compiling\ FTS3+QueryInterface.swift,\ FTS5+QueryInterface.swift,\ ForeignKey.swift,\ Association.swift,\ AssociationAggregate.swift,\ BelongsToAssociation.swift,\ HasManyAssociation.swift,\ HasManyThroughAssociation.swift,\ HasOneAssociation.swift,\ HasOneThroughAssociation.swift,\ JoinAssociation.swift,\ CommonTableExpression.swift,\ QueryInterfaceRequest.swift,\ RequestProtocols.swift,\ Column.swift,\ DatabasePromise.swift,\ SQLAssociation.swift,\ SQLCollection.swift,\ SQLExpression.swift,\ SQLForeignKeyRequest.swift,\ SQLFunctions.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/FTS3+QueryInterface.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/FTS5+QueryInterface.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/ForeignKey.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/Request/Association/Association.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/Request/Association/AssociationAggregate.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/Request/Association/BelongsToAssociation.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/Request/Association/HasManyAssociation.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/Request/Association/HasManyThroughAssociation.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/Request/Association/HasOneAssociation.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/Request/Association/HasOneThroughAssociation.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/Request/Association/JoinAssociation.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/Request/CommonTableExpression.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/Request/QueryInterfaceRequest.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/Request/RequestProtocols.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQL/Column.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQL/DatabasePromise.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQL/SQLAssociation.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQL/SQLCollection.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQL/SQLExpression.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQL/SQLForeignKeyRequest.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQL/SQLFunctions.swift (in target 'GRDB' from project 'GRDB')

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/FTS3+QueryInterface.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/FTS5+QueryInterface.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/ForeignKey.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/Request/Association/Association.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/Request/Association/AssociationAggregate.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/Request/Association/BelongsToAssociation.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/Request/Association/HasManyAssociation.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/Request/Association/HasManyThroughAssociation.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/Request/Association/HasOneAssociation.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/Request/Association/HasOneThroughAssociation.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/Request/Association/JoinAssociation.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/Request/CommonTableExpression.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/Request/QueryInterfaceRequest.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/Request/RequestProtocols.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQL/Column.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQL/DatabasePromise.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQL/SQLAssociation.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQL/SQLCollection.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQL/SQLExpression.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQL/SQLForeignKeyRequest.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQL/SQLFunctions.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 Compiling\ resource_bundle_accessor.swift,\ Configuration.swift,\ Cursor.swift,\ Database+SQLCipher.swift,\ Database+Schema.swift,\ Database+Statements.swift,\ Database.swift,\ DatabaseBackupProgress.swift,\ DatabaseCollation.swift,\ DatabaseError.swift,\ DatabaseFunction.swift,\ DatabasePool.swift,\ DatabasePublishers.swift,\ DatabaseQueue.swift,\ DatabaseReader.swift,\ DatabaseRegion.swift,\ DatabaseRegionObservation.swift,\ DatabaseSchemaCache.swift,\ DatabaseSchemaSource.swift,\ DatabaseSnapshot.swift,\ DatabaseSnapshotPool.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/DerivedSources/resource_bundle_accessor.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Configuration.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Cursor.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Database+SQLCipher.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Database+Schema.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Database+Statements.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Database.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/DatabaseBackupProgress.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/DatabaseCollation.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/DatabaseError.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/DatabaseFunction.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/DatabasePool.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/DatabasePublishers.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/DatabaseQueue.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/DatabaseReader.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/DatabaseRegion.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/DatabaseRegionObservation.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/DatabaseSchemaCache.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/DatabaseSchemaSource.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/DatabaseSnapshot.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/DatabaseSnapshotPool.swift (in target 'GRDB' from project 'GRDB')

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/DerivedSources/resource_bundle_accessor.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Configuration.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Cursor.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Database+SQLCipher.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Database+Schema.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Database+Statements.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/Database.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/DatabaseBackupProgress.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/DatabaseCollation.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/DatabaseError.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/DatabaseFunction.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/DatabasePool.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/DatabasePublishers.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/DatabaseQueue.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/DatabaseReader.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/DatabaseRegion.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/DatabaseRegionObservation.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/DatabaseSchemaCache.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/DatabaseSchemaSource.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/DatabaseSnapshot.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Core/DatabaseSnapshotPool.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 Compiling\ TableRecord+Association.swift,\ TableRecord+QueryInterfaceRequest.swift,\ EncodableRecord+Encodable.swift,\ EncodableRecord.swift,\ FetchableRecord+Decodable.swift,\ FetchableRecord+TableRecord.swift,\ FetchableRecord.swift,\ MutablePersistableRecord+DAO.swift,\ MutablePersistableRecord+Delete.swift,\ MutablePersistableRecord+Insert.swift,\ MutablePersistableRecord+Save.swift,\ MutablePersistableRecord+Update.swift,\ MutablePersistableRecord+Upsert.swift,\ MutablePersistableRecord.swift,\ PersistableRecord+Insert.swift,\ PersistableRecord+Save.swift,\ PersistableRecord+Upsert.swift,\ PersistableRecord.swift,\ Record.swift,\ TableRecord.swift,\ CaseInsensitiveIdentifier.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/TableRecord+Association.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/TableRecord+QueryInterfaceRequest.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Record/EncodableRecord+Encodable.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Record/EncodableRecord.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Record/FetchableRecord+Decodable.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Record/FetchableRecord+TableRecord.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Record/FetchableRecord.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Record/MutablePersistableRecord+DAO.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Record/MutablePersistableRecord+Delete.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Record/MutablePersistableRecord+Insert.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Record/MutablePersistableRecord+Save.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Record/MutablePersistableRecord+Update.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Record/MutablePersistableRecord+Upsert.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Record/MutablePersistableRecord.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Record/PersistableRecord+Insert.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Record/PersistableRecord+Save.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Record/PersistableRecord+Upsert.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Record/PersistableRecord.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Record/Record.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Record/TableRecord.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Utils/CaseInsensitiveIdentifier.swift (in target 'GRDB' from project 'GRDB')

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/TableRecord+Association.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/TableRecord+QueryInterfaceRequest.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Record/EncodableRecord+Encodable.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Record/EncodableRecord.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Record/FetchableRecord+Decodable.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Record/FetchableRecord+TableRecord.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Record/FetchableRecord.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Record/MutablePersistableRecord+DAO.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Record/MutablePersistableRecord+Delete.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Record/MutablePersistableRecord+Insert.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Record/MutablePersistableRecord+Save.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Record/MutablePersistableRecord+Update.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Record/MutablePersistableRecord+Upsert.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Record/MutablePersistableRecord.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Record/PersistableRecord+Insert.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Record/PersistableRecord+Save.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Record/PersistableRecord+Upsert.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Record/PersistableRecord.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Record/Record.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Record/TableRecord.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/Utils/CaseInsensitiveIdentifier.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftDriverJobDiscovery normal arm64 Emitting module for GRDB (in target 'GRDB' from project 'GRDB')

SwiftDriver\ Compilation\ Requirements GRDB normal arm64 com.apple.xcode.tools.swift.compiler (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    builtin-Swift-Compilation-Requirements -- /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swiftc -module-name GRDB -Onone -enforce-exclusivity\=checked @/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB.SwiftFileList -DSWIFT_PACKAGE -DDEBUG -DSWIFT_MODULE_RESOURCE_BUNDLE_AVAILABLE -DSQLITE_ENABLE_FTS5 -DSQLITE_ENABLE_SNAPSHOT -Xcc -fmodule-map-file\=/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/Sources/GRDBSQLite/module.modulemap -DXcode -plugin-path /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/host/plugins/testing -enable-experimental-feature DebugDescriptionMacro -sdk /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk -target arm64-apple-ios13.0-simulator -g -module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex -Xfrontend -serialize-debugging-options -enable-testing -suppress-warnings -index-store-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Index.noindex/DataStore -Xcc -D_LIBCPP_HARDENING_MODE\=_LIBCPP_HARDENING_MODE_DEBUG -swift-version 6 -I /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator -Isystem /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/usr/lib -F /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator -F /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Library/Frameworks -F /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk/Developer/Library/Frameworks -emit-localized-strings -emit-localized-strings-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64 -c -j8 -enable-batch-mode -incremental -Xcc -ivfsstatcache -Xcc /Users/noamsadi/Library/Developer/Xcode/DerivedData/SDKStatCaches.noindex/iphonesimulator26.1-23B77-3885c01c3e6b6a337905948deab2002e90cf18a4295e390e64c810bc6bd7acbc.sdkstatcache -output-file-map /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB-OutputFileMap.json -use-frontend-parseable-output -save-temps -no-color-diagnostics -explicit-module-build -module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/SwiftExplicitPrecompiledModules -clang-scanner-module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex -sdk-module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex -serialize-diagnostics -emit-dependencies -emit-module -emit-module-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB.swiftmodule -user-module-version 7.10.0 -validate-clang-modules-once -clang-build-session-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Session.modulevalidation -package-name grdb_swift -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/swift-overrides.hmap -emit-const-values -Xfrontend -const-gather-protocols-file -Xfrontend /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB_const_extract_protocols.json -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/include -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/DerivedSources-normal/arm64 -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/DerivedSources/arm64 -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/DerivedSources -Xcc -DSWIFT_PACKAGE -Xcc -DDEBUG\=1 -emit-objc-header -emit-objc-header-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB-Swift.h -working-directory /Users/noamsadi/A-Pub/EpubReader.xcodeproj -experimental-emit-module-separately -disable-cmo

SwiftCompile normal arm64 Compiling\ SQLOperators.swift,\ SQLOrdering.swift,\ SQLRelation.swift,\ SQLSelection.swift,\ SQLSubquery.swift,\ Table.swift,\ SQLColumnGenerator.swift,\ SQLGenerationContext.swift,\ SQLIndexGenerator.swift,\ SQLQueryGenerator.swift,\ SQLTableAlterationGenerator.swift,\ SQLTableGenerator.swift,\ TableAlias.swift,\ SQLInterpolation+QueryInterface.swift,\ ColumnDefinition.swift,\ Database+SchemaDefinition.swift,\ ForeignKeyDefinition.swift,\ IndexDefinition.swift,\ TableAlteration.swift,\ TableDefinition.swift,\ VirtualTableModule.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQL/SQLOperators.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQL/SQLOrdering.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQL/SQLRelation.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQL/SQLSelection.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQL/SQLSubquery.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQL/Table.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQLGeneration/SQLColumnGenerator.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQLGeneration/SQLGenerationContext.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQLGeneration/SQLIndexGenerator.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQLGeneration/SQLQueryGenerator.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQLGeneration/SQLTableAlterationGenerator.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQLGeneration/SQLTableGenerator.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQLGeneration/TableAlias.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQLInterpolation+QueryInterface.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/Schema/ColumnDefinition.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/Schema/Database+SchemaDefinition.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/Schema/ForeignKeyDefinition.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/Schema/IndexDefinition.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/Schema/TableAlteration.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/Schema/TableDefinition.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/Schema/VirtualTableModule.swift (in target 'GRDB' from project 'GRDB')

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQL/SQLOperators.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQL/SQLOrdering.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQL/SQLRelation.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQL/SQLSelection.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQL/SQLSubquery.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQL/Table.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQLGeneration/SQLColumnGenerator.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQLGeneration/SQLGenerationContext.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQLGeneration/SQLIndexGenerator.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQLGeneration/SQLQueryGenerator.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQLGeneration/SQLTableAlterationGenerator.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQLGeneration/SQLTableGenerator.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQLGeneration/TableAlias.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/SQLInterpolation+QueryInterface.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/Schema/ColumnDefinition.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/Schema/Database+SchemaDefinition.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/Schema/ForeignKeyDefinition.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/Schema/IndexDefinition.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/Schema/TableAlteration.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/Schema/TableDefinition.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/GRDB/QueryInterface/Schema/VirtualTableModule.swift (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    

SwiftMergeGeneratedHeaders /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GeneratedModuleMaps-iphonesimulator/GRDB-Swift.h /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB-Swift.h (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift
    builtin-swiftHeaderTool -arch arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB-Swift.h -o /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GeneratedModuleMaps-iphonesimulator/GRDB-Swift.h

SwiftDriverJobDiscovery normal arm64 Compiling DebugDumpFormat.swift, JSONDumpFormat.swift, LineDumpFormat.swift, ListDumpFormat.swift, QuoteDumpFormat.swift, FTS3.swift, FTS3Pattern.swift, FTS3TokenizerDescriptor.swift, FTS4.swift, FTS5.swift, FTS5CustomTokenizer.swift, FTS5Pattern.swift, FTS5Tokenizer.swift, FTS5TokenizerDescriptor.swift, FTS5WrapperTokenizer.swift, Fixits.swift, JSONColumn.swift, SQLJSONExpressible.swift, SQLJSONFunctions.swift, DatabaseMigrator.swift, Migration.swift (in target 'GRDB' from project 'GRDB')

Copy /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/GRDB.swiftmodule/arm64-apple-ios-simulator.swiftmodule /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB.swiftmodule (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift
    builtin-copy -exclude .DS_Store -exclude CVS -exclude .svn -exclude .git -exclude .hg -resolve-src-symlinks -rename /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB.swiftmodule /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/GRDB.swiftmodule/arm64-apple-ios-simulator.swiftmodule

Copy /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/GRDB.swiftmodule/arm64-apple-ios-simulator.swiftdoc /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB.swiftdoc (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift
    builtin-copy -exclude .DS_Store -exclude CVS -exclude .svn -exclude .git -exclude .hg -resolve-src-symlinks -rename /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB.swiftdoc /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/GRDB.swiftmodule/arm64-apple-ios-simulator.swiftdoc

Copy /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/GRDB.swiftmodule/arm64-apple-ios-simulator.abi.json /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB.abi.json (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift
    builtin-copy -exclude .DS_Store -exclude CVS -exclude .svn -exclude .git -exclude .hg -resolve-src-symlinks -rename /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB.abi.json /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/GRDB.swiftmodule/arm64-apple-ios-simulator.abi.json

Copy /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/GRDB.swiftmodule/Project/arm64-apple-ios-simulator.swiftsourceinfo /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB.swiftsourceinfo (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift
    builtin-copy -exclude .DS_Store -exclude CVS -exclude .svn -exclude .git -exclude .hg -resolve-src-symlinks -rename /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB.swiftsourceinfo /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/GRDB.swiftmodule/Project/arm64-apple-ios-simulator.swiftsourceinfo

SwiftDriverJobDiscovery normal arm64 Compiling Inflections+English.swift, Inflections.swift, Mutex.swift, OnDemandFuture.swift, OrderedDictionary.swift, Pool.swift, ReadWriteLock.swift, ReceiveValuesOn.swift, Refinable.swift, Utils.swift, DatabaseCancellable.swift, ValueConcurrentObserver.swift, ValueWriteOnlyObserver.swift, Fetch.swift, Map.swift, RemoveDuplicates.swift, Trace.swift, ValueReducer.swift, SharedValueObservation.swift, ValueObservation.swift, ValueObservationScheduler.swift (in target 'GRDB' from project 'GRDB')

SwiftDriverJobDiscovery normal arm64 Compiling Decimal.swift, NSData.swift, NSNull.swift, NSNumber.swift, NSString.swift, SQLiteDateParser.swift, URL.swift, UUID.swift, DatabaseValueConvertible+Decodable.swift, DatabaseValueConvertible+Encodable.swift, DatabaseValueConvertible+RawRepresentable.swift, JSONRequiredEncoder.swift, Optional.swift, StandardLibrary.swift, TransactionClock.swift, TransactionObserver.swift, WALSnapshot.swift, WALSnapshotTransaction.swift, Database+Dump.swift, DatabaseReader+dump.swift, DumpFormat.swift (in target 'GRDB' from project 'GRDB')

SwiftDriverJobDiscovery normal arm64 Compiling FTS3+QueryInterface.swift, FTS5+QueryInterface.swift, ForeignKey.swift, Association.swift, AssociationAggregate.swift, BelongsToAssociation.swift, HasManyAssociation.swift, HasManyThroughAssociation.swift, HasOneAssociation.swift, HasOneThroughAssociation.swift, JoinAssociation.swift, CommonTableExpression.swift, QueryInterfaceRequest.swift, RequestProtocols.swift, Column.swift, DatabasePromise.swift, SQLAssociation.swift, SQLCollection.swift, SQLExpression.swift, SQLForeignKeyRequest.swift, SQLFunctions.swift (in target 'GRDB' from project 'GRDB')

SwiftDriverJobDiscovery normal arm64 Compiling TableRecord+Association.swift, TableRecord+QueryInterfaceRequest.swift, EncodableRecord+Encodable.swift, EncodableRecord.swift, FetchableRecord+Decodable.swift, FetchableRecord+TableRecord.swift, FetchableRecord.swift, MutablePersistableRecord+DAO.swift, MutablePersistableRecord+Delete.swift, MutablePersistableRecord+Insert.swift, MutablePersistableRecord+Save.swift, MutablePersistableRecord+Update.swift, MutablePersistableRecord+Upsert.swift, MutablePersistableRecord.swift, PersistableRecord+Insert.swift, PersistableRecord+Save.swift, PersistableRecord+Upsert.swift, PersistableRecord.swift, Record.swift, TableRecord.swift, CaseInsensitiveIdentifier.swift (in target 'GRDB' from project 'GRDB')

SwiftDriverJobDiscovery normal arm64 Compiling DatabaseValue.swift, DatabaseValueConvertible.swift, DatabaseWriter.swift, DispatchQueueActor.swift, FetchRequest.swift, Row.swift, RowAdapter.swift, RowDecodingError.swift, SQL.swift, SQLInterpolation.swift, SQLRequest.swift, SchedulingWatchdog.swift, SerializedDatabase.swift, Statement.swift, StatementAuthorizer.swift, StatementColumnConvertible.swift, CGFloat.swift, Data.swift, DatabaseDateComponents.swift, DatabaseValueConvertible+ReferenceConvertible.swift, Date.swift (in target 'GRDB' from project 'GRDB')

SwiftDriverJobDiscovery normal arm64 Compiling resource_bundle_accessor.swift, Configuration.swift, Cursor.swift, Database+SQLCipher.swift, Database+Schema.swift, Database+Statements.swift, Database.swift, DatabaseBackupProgress.swift, DatabaseCollation.swift, DatabaseError.swift, DatabaseFunction.swift, DatabasePool.swift, DatabasePublishers.swift, DatabaseQueue.swift, DatabaseReader.swift, DatabaseRegion.swift, DatabaseRegionObservation.swift, DatabaseSchemaCache.swift, DatabaseSchemaSource.swift, DatabaseSnapshot.swift, DatabaseSnapshotPool.swift (in target 'GRDB' from project 'GRDB')

SwiftDriverJobDiscovery normal arm64 Compiling SQLOperators.swift, SQLOrdering.swift, SQLRelation.swift, SQLSelection.swift, SQLSubquery.swift, Table.swift, SQLColumnGenerator.swift, SQLGenerationContext.swift, SQLIndexGenerator.swift, SQLQueryGenerator.swift, SQLTableAlterationGenerator.swift, SQLTableGenerator.swift, TableAlias.swift, SQLInterpolation+QueryInterface.swift, ColumnDefinition.swift, Database+SchemaDefinition.swift, ForeignKeyDefinition.swift, IndexDefinition.swift, TableAlteration.swift, TableDefinition.swift, VirtualTableModule.swift (in target 'GRDB' from project 'GRDB')

SwiftDriver\ Compilation GRDB normal arm64 com.apple.xcode.tools.swift.compiler (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/A-Pub/EpubReader.xcodeproj
    builtin-Swift-Compilation -- /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swiftc -module-name GRDB -Onone -enforce-exclusivity\=checked @/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB.SwiftFileList -DSWIFT_PACKAGE -DDEBUG -DSWIFT_MODULE_RESOURCE_BUNDLE_AVAILABLE -DSQLITE_ENABLE_FTS5 -DSQLITE_ENABLE_SNAPSHOT -Xcc -fmodule-map-file\=/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/Sources/GRDBSQLite/module.modulemap -DXcode -plugin-path /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/host/plugins/testing -enable-experimental-feature DebugDescriptionMacro -sdk /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk -target arm64-apple-ios13.0-simulator -g -module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex -Xfrontend -serialize-debugging-options -enable-testing -suppress-warnings -index-store-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Index.noindex/DataStore -Xcc -D_LIBCPP_HARDENING_MODE\=_LIBCPP_HARDENING_MODE_DEBUG -swift-version 6 -I /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator -Isystem /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/usr/lib -F /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator -F /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Library/Frameworks -F /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk/Developer/Library/Frameworks -emit-localized-strings -emit-localized-strings-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64 -c -j8 -enable-batch-mode -incremental -Xcc -ivfsstatcache -Xcc /Users/noamsadi/Library/Developer/Xcode/DerivedData/SDKStatCaches.noindex/iphonesimulator26.1-23B77-3885c01c3e6b6a337905948deab2002e90cf18a4295e390e64c810bc6bd7acbc.sdkstatcache -output-file-map /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB-OutputFileMap.json -use-frontend-parseable-output -save-temps -no-color-diagnostics -explicit-module-build -module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/SwiftExplicitPrecompiledModules -clang-scanner-module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex -sdk-module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex -serialize-diagnostics -emit-dependencies -emit-module -emit-module-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB.swiftmodule -user-module-version 7.10.0 -validate-clang-modules-once -clang-build-session-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Session.modulevalidation -package-name grdb_swift -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/swift-overrides.hmap -emit-const-values -Xfrontend -const-gather-protocols-file -Xfrontend /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB_const_extract_protocols.json -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/include -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/DerivedSources-normal/arm64 -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/DerivedSources/arm64 -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/DerivedSources -Xcc -DSWIFT_PACKAGE -Xcc -DDEBUG\=1 -emit-objc-header -emit-objc-header-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB-Swift.h -working-directory /Users/noamsadi/A-Pub/EpubReader.xcodeproj -experimental-emit-module-separately -disable-cmo

Ld /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/GRDB.o normal (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift
    /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -Xlinker -reproducible -target arm64-apple-ios13.0-simulator -r -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk -O0 -w -L/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EagerLinkingTBDs/Debug-iphonesimulator -L/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator -L/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/usr/lib -F/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EagerLinkingTBDs/Debug-iphonesimulator -F/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator -iframework /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Library/Frameworks -iframework /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk/Developer/Library/Frameworks -filelist /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB.LinkFileList -nostdlib -Xlinker -object_path_lto -Xlinker /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB_lto.o -rdynamic -Xlinker -no_deduplicate -Xlinker -objc_abi_version -Xlinker 2 -Xlinker -dependency_info -Xlinker /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB_dependency_info.dat -fobjc-link-runtime -L/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphonesimulator -L/usr/lib/swift -Xlinker -add_ast_path -Xlinker /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB.swiftmodule @/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB-linker-args.resp -o /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/GRDB.o

ExtractAppIntentsMetadata (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift
    /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/appintentsmetadataprocessor --toolchain-dir /var/run/com.apple.security.cryptexd/mnt/com.apple.MobileAsset.MetalToolchain-v17.2.54.0.B5ESTF/Metal.xctoolchain --module-name GRDB --sdk-root /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk --xcode-version 17B55 --platform-family iOS --deployment-target 13.0 --bundle-identifier grdb.swift.GRDB --output /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/GRDB.appintents --target-triple arm64-apple-ios13.0-simulator --binary-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/GRDB.o --dependency-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB_dependency_info.dat --stringsdata-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/ExtractedAppShortcutsMetadata.stringsdata --source-file-list /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB.SwiftFileList --metadata-file-list /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/GRDB.DependencyMetadataFileList --static-metadata-file-list /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/GRDB.DependencyStaticMetadataFileList --swift-const-vals-list /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/GRDB.build/Debug-iphonesimulator/GRDB.build/Objects-normal/arm64/GRDB.SwiftConstValuesFileList --force --compile-time-extraction --deployment-aware-processing --validate-assistant-intents --no-app-shortcuts-localization

2026-04-26 10:43:14.272 appintentsmetadataprocessor[37245:13560041] Starting appintentsmetadataprocessor export
2026-04-26 10:43:14.458 appintentsmetadataprocessor[37245:13560041] Extracted no relevant App Intents symbols, skipping writing output

RegisterExecutionPolicyException /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/GRDB.o (in target 'GRDB' from project 'GRDB')
    cd /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift
    builtin-RegisterExecutionPolicyException /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/GRDB.o


Build target EpubReader of project EpubReader with configuration Debug

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader.hmap (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader.hmap

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader.DependencyStaticMetadataFileList (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader.DependencyStaticMetadataFileList

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader.SwiftFileList (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader.SwiftFileList

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader_const_extract_protocols.json (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader_const_extract_protocols.json

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader.SwiftConstValuesFileList (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader.SwiftConstValuesFileList

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader.LinkFileList (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader.LinkFileList

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader-OutputFileMap.json (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader-OutputFileMap.json

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader.DependencyMetadataFileList (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader.DependencyMetadataFileList

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-project-headers.hmap (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-project-headers.hmap

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-own-target-headers.hmap (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-own-target-headers.hmap

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-generated-files.hmap (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-generated-files.hmap

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-all-target-headers.hmap (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-all-target-headers.hmap

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-all-non-framework-target-headers.hmap (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-all-non-framework-target-headers.hmap

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-DebugDylibPath-normal-arm64.txt (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-DebugDylibPath-normal-arm64.txt

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-DebugDylibInstallName-normal-arm64.txt (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-DebugDylibInstallName-normal-arm64.txt

WriteAuxiliaryFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/Entitlements-Simulated.plist (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    write-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/Entitlements-Simulated.plist

MkDir /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    /bin/mkdir -p /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app

ProcessProductPackaging "" /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader.app-Simulated.xcent (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    
    Entitlements:
    
    {
    "application-identifier" = "B3X5JXT7NJ.com.yourname.epubreader";
}
    
    builtin-productPackagingUtility -entitlements -format xml -o /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader.app-Simulated.xcent

ProcessProductPackagingDER /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader.app-Simulated.xcent /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader.app-Simulated.xcent.der (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    /usr/bin/derq query -f xml -i /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader.app-Simulated.xcent -o /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader.app-Simulated.xcent.der --raw

MkDir /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/assetcatalog_output/thinned (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    /bin/mkdir -p /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/assetcatalog_output/thinned

MkDir /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/assetcatalog_output/unthinned (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    /bin/mkdir -p /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/assetcatalog_output/unthinned

GenerateAssetSymbols /Users/noamsadi/A-Pub/EpubReader/Preview\ Content/Preview\ Assets.xcassets /Users/noamsadi/A-Pub/EpubReader/Assets.xcassets (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    /Applications/Xcode.app/Contents/Developer/usr/bin/actool /Users/noamsadi/A-Pub/EpubReader/Preview\ Content/Preview\ Assets.xcassets /Users/noamsadi/A-Pub/EpubReader/Assets.xcassets --compile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app --output-format human-readable-text --notices --warnings --export-dependency-info /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/assetcatalog_dependencies --output-partial-info-plist /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/assetcatalog_generated_info.plist --app-icon AppIcon --accent-color AccentColor --compress-pngs --enable-on-demand-resources YES --development-region en --target-device iphone --target-device ipad --minimum-deployment-target 17.0 --platform iphonesimulator --bundle-identifier com.yourname.epubreader --generate-swift-asset-symbols /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/GeneratedAssetSymbols.swift --generate-objc-asset-symbols /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/GeneratedAssetSymbols.h --generate-asset-symbol-index /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/GeneratedAssetSymbols-Index.plist

/* com.apple.actool.compilation-results */
/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/GeneratedAssetSymbols-Index.plist
/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/GeneratedAssetSymbols.h
/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/GeneratedAssetSymbols.swift


DataModelCompile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app/ /Users/noamsadi/A-Pub/EpubReader/EpubReader.xcdatamodeld (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    /Applications/Xcode.app/Contents/Developer/usr/bin/momc --sdkroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk --iphonesimulator-deployment-target 17.0 --module EpubReader /Users/noamsadi/A-Pub/EpubReader/EpubReader.xcdatamodeld /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app/

EpubReader.xcdatamodel: note: Model EpubReader version checksum: Elz8+yJ9w3LPoImEsnvjiYTjYn1+ATXSlr+oIQkLa1I=

/Users/noamsadi/A-Pub/EpubReader.xcdatamodel:1:1: Model EpubReader version checksum: Elz8+yJ9w3LPoImEsnvjiYTjYn1+ATXSlr+oIQkLa1I=

DataModelCodegen /Users/noamsadi/A-Pub/EpubReader/EpubReader.xcdatamodeld (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    /Applications/Xcode.app/Contents/Developer/usr/bin/momc --action generate --swift-version 6.0 --sdkroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk --iphonesimulator-deployment-target 17.0 --module EpubReader /Users/noamsadi/A-Pub/EpubReader/EpubReader.xcdatamodeld /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader

CompileAssetCatalogVariant thinned /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app /Users/noamsadi/A-Pub/EpubReader/Preview\ Content/Preview\ Assets.xcassets /Users/noamsadi/A-Pub/EpubReader/Assets.xcassets (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    /Applications/Xcode.app/Contents/Developer/usr/bin/actool /Users/noamsadi/A-Pub/EpubReader/Preview\ Content/Preview\ Assets.xcassets /Users/noamsadi/A-Pub/EpubReader/Assets.xcassets --compile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/assetcatalog_output/thinned --output-format human-readable-text --notices --warnings --export-dependency-info /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/assetcatalog_dependencies_thinned --output-partial-info-plist /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/assetcatalog_generated_info.plist_thinned --app-icon AppIcon --accent-color AccentColor --compress-pngs --enable-on-demand-resources YES --filter-for-thinning-device-configuration iPhone18,3 --filter-for-device-os-version 26.1 --development-region en --target-device iphone --target-device ipad --minimum-deployment-target 17.0 --platform iphonesimulator

/* com.apple.actool.compilation-results */
/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/assetcatalog_generated_info.plist_thinned
/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/assetcatalog_output/thinned/Assets.car


SwiftDriver EpubReader normal arm64 com.apple.xcode.tools.swift.compiler (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    builtin-SwiftDriver -- /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swiftc -module-name EpubReader -Onone -enforce-exclusivity\=checked @/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader.SwiftFileList -DDEBUG -Xcc -fmodule-map-file\=/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/Sources/GRDBSQLite/module.modulemap -enable-experimental-feature DebugDescriptionMacro -sdk /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk -target arm64-apple-ios17.0-simulator -g -module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex -Xfrontend -serialize-debugging-options -enable-testing -index-store-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Index.noindex/DataStore -Xcc -D_LIBCPP_HARDENING_MODE\=_LIBCPP_HARDENING_MODE_DEBUG -swift-version 6 -I /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator -F /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/PackageFrameworks -F /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/PackageFrameworks -F /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator -emit-localized-strings -emit-localized-strings-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64 -c -j8 -enable-batch-mode -incremental -Xcc -ivfsstatcache -Xcc /Users/noamsadi/Library/Developer/Xcode/DerivedData/SDKStatCaches.noindex/iphonesimulator26.1-23B77-3885c01c3e6b6a337905948deab2002e90cf18a4295e390e64c810bc6bd7acbc.sdkstatcache -output-file-map /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader-OutputFileMap.json -use-frontend-parseable-output -save-temps -no-color-diagnostics -explicit-module-build -module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/SwiftExplicitPrecompiledModules -clang-scanner-module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex -sdk-module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex -serialize-diagnostics -emit-dependencies -emit-module -emit-module-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader.swiftmodule -validate-clang-modules-once -clang-build-session-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Session.modulevalidation -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/swift-overrides.hmap -emit-const-values -Xfrontend -const-gather-protocols-file -Xfrontend /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader_const_extract_protocols.json -Xcc -iquote -Xcc /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-generated-files.hmap -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-own-target-headers.hmap -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-all-non-framework-target-headers.hmap -Xcc -ivfsoverlay -Xcc /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader-4d5c3879ad9b5d9dced6c7c32c3b37ba-VFS-iphonesimulator/all-product-headers.yaml -Xcc -iquote -Xcc /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-project-headers.hmap -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/include -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources-normal/arm64 -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/arm64 -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources -Xcc -DDEBUG\=1 -emit-objc-header -emit-objc-header-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader-Swift.h -working-directory /Users/noamsadi/A-Pub -experimental-emit-module-separately -disable-cmo

SwiftCompile normal arm64 Compiling\ LeakAvoider.swift,\ EPUBBridge.swift,\ EPUBWebView.swift,\ FileImporter.swift,\ ReaderView.swift,\ ReaderViewModel.swift /Users/noamsadi/A-Pub/EpubReader/Core/Utilities/LeakAvoider.swift /Users/noamsadi/A-Pub/EpubReader/Features/Reader/EPUBBridge.swift /Users/noamsadi/A-Pub/EpubReader/Features/Reader/EPUBWebView.swift /Users/noamsadi/A-Pub/EpubReader/Core/Utilities/FileImporter.swift /Users/noamsadi/A-Pub/EpubReader/Features/Reader/ReaderView.swift /Users/noamsadi/A-Pub/EpubReader/Features/Reader/ReaderViewModel.swift (in target 'EpubReader' from project 'EpubReader')

Failed frontend command:
/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift-frontend -frontend -c /Users/noamsadi/A-Pub/EpubReader/App/AppEntry.swift /Users/noamsadi/A-Pub/EpubReader/Core/Utilities/Logger.swift /Users/noamsadi/A-Pub/EpubReader/Core/EPUB/EPUBExtractor.swift /Users/noamsadi/A-Pub/EpubReader/Core/EPUB/EPUBChapter.swift /Users/noamsadi/A-Pub/EpubReader/Core/EPUB/EPUBBook.swift /Users/noamsadi/A-Pub/EpubReader/Core/EPUB/EPUBParser.swift -primary-file /Users/noamsadi/A-Pub/EpubReader/Core/Utilities/LeakAvoider.swift -primary-file /Users/noamsadi/A-Pub/EpubReader/Features/Reader/EPUBBridge.swift -primary-file /Users/noamsadi/A-Pub/EpubReader/Features/Reader/EPUBWebView.swift -primary-file /Users/noamsadi/A-Pub/EpubReader/Core/Utilities/FileImporter.swift -primary-file /Users/noamsadi/A-Pub/EpubReader/Features/Reader/ReaderView.swift -primary-file /Users/noamsadi/A-Pub/EpubReader/Features/Reader/ReaderViewModel.swift /Users/noamsadi/A-Pub/EpubReader/Core/Persistence/PersistenceController.swift /Users/noamsadi/A-Pub/EpubReader/Core/Utilities/MetadataExtractor.swift /Users/noamsadi/A-Pub/EpubReader/Core/Utilities/CoverImageExtractor.swift /Users/noamsadi/A-Pub/EpubReader/Features/Library/LibraryView.swift /Users/noamsadi/A-Pub/EpubReader/Features/Library/LibraryViewModel.swift /Users/noamsadi/A-Pub/EpubReader/Features/Library/BookGridCell.swift /Users/noamsadi/A-Pub/EpubReader/Features/Library/BookListCell.swift /Users/noamsadi/A-Pub/EpubReader/Features/Library/BookDetailView.swift /Users/noamsadi/A-Pub/EpubReader/Features/Library/ShelfView.swift /Users/noamsadi/A-Pub/EpubReader/Features/Reader/PageController.swift /Users/noamsadi/A-Pub/EpubReader/Features/Reader/PageCurlViewController.swift /Users/noamsadi/A-Pub/EpubReader/Features/Reader/ReaderSettings.swift /Users/noamsadi/A-Pub/EpubReader/Features/Settings/AppearanceSettings.swift /Users/noamsadi/A-Pub/EpubReader/Core/Models/Book.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Book+CoreDataClass.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Book+CoreDataProperties.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Shelf+CoreDataClass.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Shelf+CoreDataProperties.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/ShelfMembership+CoreDataClass.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/ShelfMembership+CoreDataProperties.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/ReadingProgress+CoreDataClass.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/ReadingProgress+CoreDataProperties.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Highlight+CoreDataClass.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Highlight+CoreDataProperties.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Bookmark+CoreDataClass.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Bookmark+CoreDataProperties.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/ReadingSession+CoreDataClass.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/ReadingSession+CoreDataProperties.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/EpubReader+CoreDataModel.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/GeneratedAssetSymbols.swift -supplementary-output-file-map /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/supplementaryOutputs-187 -emit-localized-strings -emit-localized-strings-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64 -target arm64-apple-ios17.0-simulator -module-can-import-version DeveloperToolsSupport 23.0.4 23.0.4 -module-can-import-version SwiftUI 7.1.13.1 7.1.13 -module-can-import-version UIKit 9126.1.12.1 9126.1.12 -disable-cross-import-overlay-search -swift-module-cross-import CoreData /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/System/Library/Frameworks/CoreData.framework/Modules/CoreData.swiftcrossimport/CloudKit.swiftoverlay -swift-module-cross-import CoreData /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk/System/Library/Frameworks/CoreData.framework/Modules/CoreData.swiftcrossimport/CloudKit.swiftoverlay -swift-module-cross-import WebKit /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/System/Cryptexes/OS/System/Library/Frameworks/WebKit.framework/Modules/WebKit.swiftcrossimport/SwiftUI.swiftoverlay -swift-module-cross-import WebKit /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk/System/Library/Frameworks/WebKit.framework/Modules/WebKit.swiftcrossimport/SwiftUI.swiftoverlay -load-resolved-plugin /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/lib/swift/host/plugins/libFoundationMacros.dylib\#/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/swift-plugin-server\#FoundationMacros -load-resolved-plugin /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/lib/swift/host/plugins/libObservationMacros.dylib\#/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/swift-plugin-server\#ObservationMacros -load-resolved-plugin /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/lib/swift/host/plugins/libPreviewsMacros.dylib\#/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/swift-plugin-server\#PreviewsMacros -load-resolved-plugin /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/lib/swift/host/plugins/libSwiftMacros.dylib\#/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/swift-plugin-server\#SwiftMacros -load-resolved-plugin /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/lib/swift/host/plugins/libSwiftUIMacros.dylib\#/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/swift-plugin-server\#SwiftUIMacros -disable-implicit-swift-modules -Xcc -fno-implicit-modules -Xcc -fno-implicit-module-maps -explicit-swift-module-map-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader-dependencies-28.json -Xllvm -aarch64-use-tbi -enable-objc-interop -sdk /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk -I /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator -F /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/PackageFrameworks -F /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/PackageFrameworks -F /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator -no-color-diagnostics -Xcc -fno-color-diagnostics -enable-testing -g -debug-info-format\=dwarf -dwarf-version\=4 -module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/SwiftExplicitPrecompiledModules -swift-version 6 -enforce-exclusivity\=checked -Onone -D DEBUG -serialize-debugging-options -const-gather-protocols-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader_const_extract_protocols.json -enable-experimental-feature DebugDescriptionMacro -empty-abi-descriptor -validate-clang-modules-once -clang-build-session-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Session.modulevalidation -Xcc -working-directory -Xcc /Users/noamsadi/A-Pub -enable-anonymous-context-mangled-names -file-compilation-dir /Users/noamsadi/A-Pub -Xcc -fmodule-map-file\=/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/Sources/GRDBSQLite/module.modulemap -Xcc -D_LIBCPP_HARDENING_MODE\=_LIBCPP_HARDENING_MODE_DEBUG -Xcc -ivfsstatcache -Xcc /Users/noamsadi/Library/Developer/Xcode/DerivedData/SDKStatCaches.noindex/iphonesimulator26.1-23B77-3885c01c3e6b6a337905948deab2002e90cf18a4295e390e64c810bc6bd7acbc.sdkstatcache -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/swift-overrides.hmap -Xcc -iquote -Xcc /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-generated-files.hmap -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-own-target-headers.hmap -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-all-non-framework-target-headers.hmap -Xcc -ivfsoverlay -Xcc /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader-4d5c3879ad9b5d9dced6c7c32c3b37ba-VFS-iphonesimulator/all-product-headers.yaml -Xcc -iquote -Xcc /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-project-headers.hmap -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/include -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources-normal/arm64 -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/arm64 -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources -Xcc -DDEBUG\=1 -no-auto-bridging-header-chaining -module-name EpubReader -frontend-parseable-output -disable-clang-spi -target-sdk-version 26.1 -target-sdk-name iphonesimulator26.1 -clang-target arm64-apple-ios26.1-simulator -in-process-plugin-server-path /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/host/libSwiftInProcPluginServer.dylib -o /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/LeakAvoider.o -o /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EPUBBridge.o -o /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EPUBWebView.o -o /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/FileImporter.o -o /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/ReaderView.o -o /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/ReaderViewModel.o -index-unit-output-path /EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/LeakAvoider.o -index-unit-output-path /EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EPUBBridge.o -index-unit-output-path /EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EPUBWebView.o -index-unit-output-path /EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/FileImporter.o -index-unit-output-path /EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/ReaderView.o -index-unit-output-path /EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/ReaderViewModel.o -index-store-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Index.noindex/DataStore -index-system-modules

SwiftCompile normal arm64 /Users/noamsadi/A-Pub/EpubReader/Core/Utilities/LeakAvoider.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftCompile normal arm64 /Users/noamsadi/A-Pub/EpubReader/Features/Reader/EPUBBridge.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftCompile normal arm64 /Users/noamsadi/A-Pub/EpubReader/Features/Reader/EPUBWebView.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

/Users/noamsadi/A-Pub/EpubReader/Features/Reader/EPUBWebView.swift:83:56: warning: main actor-isolated property 'webView' can not be referenced from a Sendable closure
                    guard let self, let webView = self.webView else { return }
                                                       ^
/Users/noamsadi/A-Pub/EpubReader/Features/Reader/EPUBWebView.swift:61:26: note: property declared here
        private weak var webView: WKWebView?
                         ^
/Users/noamsadi/A-Pub/EpubReader/Features/Reader/EPUBWebView.swift:84:26: warning: main actor-isolated property 'currentSize' can not be mutated from a Sendable closure
                    self.currentSize = .zero
                         ^
/Users/noamsadi/A-Pub/EpubReader/Features/Reader/EPUBWebView.swift:62:21: note: mutation of this property is only permitted within the actor
        private var currentSize: CGSize = .zero
                    ^
/Users/noamsadi/A-Pub/EpubReader/Features/Reader/EPUBWebView.swift:85:26: warning: call to main actor-isolated instance method 'resizeIfNeeded(for:)' in a synchronous nonisolated context
                    self.resizeIfNeeded(for: webView)
                         ^
/Users/noamsadi/A-Pub/EpubReader/Features/Reader/EPUBWebView.swift:90:14: note: calls to instance method 'resizeIfNeeded(for:)' from outside of its actor context are implicitly asynchronous
        func resizeIfNeeded(for webView: WKWebView) {
             ^
/Users/noamsadi/A-Pub/EpubReader/Features/Reader/EPUBWebView.swift:90:14: note: main actor isolation inferred from conformance to protocol 'WKNavigationDelegate'
        func resizeIfNeeded(for webView: WKWebView) {
             ^

SwiftCompile normal arm64 /Users/noamsadi/A-Pub/EpubReader/Core/Utilities/FileImporter.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

/Users/noamsadi/A-Pub/EpubReader/Core/Utilities/FileImporter.swift:230:17: error: cannot pass immutable value as inout argument: 'coordinator' is a 'let' constant
                &AssociatedKeys.coordinator,
                ^~~~~~~~~~~~~~~~~~~~~~~~~~~
/Users/noamsadi/A-Pub/EpubReader/Core/Utilities/FileImporter.swift:282:12: note: change 'let' to 'var' to make it mutable
    static let coordinator: UInt8 = 0
           ^~~
           var

/Users/noamsadi/A-Pub/EpubReader/Core/Utilities/FileImporter.swift:230:17: Cannot pass immutable value as inout argument: 'coordinator' is a 'let' constant

SwiftCompile normal arm64 /Users/noamsadi/A-Pub/EpubReader/Features/Reader/ReaderView.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftCompile normal arm64 /Users/noamsadi/A-Pub/EpubReader/Features/Reader/ReaderViewModel.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

/Users/noamsadi/A-Pub/EpubReader/Features/Reader/ReaderViewModel.swift:250:9: error: ambiguous use of 'init(name:priority:operation:)'
        Task {
        ^
_Concurrency.Task.init:4:10: note: found this candidate in module '_Concurrency'
  public init(name: String? = nil, priority: TaskPriority? = nil, operation: sending @escaping @isolated(any) () async -> Success)}
         ^
_Concurrency.Task.init:4:10: note: found this candidate in module '_Concurrency'
  public init(name: String? = nil, priority: TaskPriority? = nil, operation: sending @escaping @isolated(any) () async throws -> Success)}
         ^

/Users/noamsadi/A-Pub/EpubReader/Features/Reader/ReaderViewModel.swift:250:9: Ambiguous use of 'init(name:priority:operation:)'

SwiftEmitModule normal arm64 Emitting\ module\ for\ EpubReader (in target 'EpubReader' from project 'EpubReader')

Internal Error: dataCorrupted(Swift.DecodingError.Context(codingPath: [], debugDescription: "Corrupted JSON", underlyingError: Optional(unexpected end of file)))
Failed frontend command:
/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift-frontend -frontend -emit-module -experimental-skip-non-inlinable-function-bodies-without-types /Users/noamsadi/A-Pub/EpubReader/App/AppEntry.swift /Users/noamsadi/A-Pub/EpubReader/Core/Utilities/Logger.swift /Users/noamsadi/A-Pub/EpubReader/Core/EPUB/EPUBExtractor.swift /Users/noamsadi/A-Pub/EpubReader/Core/EPUB/EPUBChapter.swift /Users/noamsadi/A-Pub/EpubReader/Core/EPUB/EPUBBook.swift /Users/noamsadi/A-Pub/EpubReader/Core/EPUB/EPUBParser.swift /Users/noamsadi/A-Pub/EpubReader/Core/Utilities/LeakAvoider.swift /Users/noamsadi/A-Pub/EpubReader/Features/Reader/EPUBBridge.swift /Users/noamsadi/A-Pub/EpubReader/Features/Reader/EPUBWebView.swift /Users/noamsadi/A-Pub/EpubReader/Core/Utilities/FileImporter.swift /Users/noamsadi/A-Pub/EpubReader/Features/Reader/ReaderView.swift /Users/noamsadi/A-Pub/EpubReader/Features/Reader/ReaderViewModel.swift /Users/noamsadi/A-Pub/EpubReader/Core/Persistence/PersistenceController.swift /Users/noamsadi/A-Pub/EpubReader/Core/Utilities/MetadataExtractor.swift /Users/noamsadi/A-Pub/EpubReader/Core/Utilities/CoverImageExtractor.swift /Users/noamsadi/A-Pub/EpubReader/Features/Library/LibraryView.swift /Users/noamsadi/A-Pub/EpubReader/Features/Library/LibraryViewModel.swift /Users/noamsadi/A-Pub/EpubReader/Features/Library/BookGridCell.swift /Users/noamsadi/A-Pub/EpubReader/Features/Library/BookListCell.swift /Users/noamsadi/A-Pub/EpubReader/Features/Library/BookDetailView.swift /Users/noamsadi/A-Pub/EpubReader/Features/Library/ShelfView.swift /Users/noamsadi/A-Pub/EpubReader/Features/Reader/PageController.swift /Users/noamsadi/A-Pub/EpubReader/Features/Reader/PageCurlViewController.swift /Users/noamsadi/A-Pub/EpubReader/Features/Reader/ReaderSettings.swift /Users/noamsadi/A-Pub/EpubReader/Features/Settings/AppearanceSettings.swift /Users/noamsadi/A-Pub/EpubReader/Core/Models/Book.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Book+CoreDataClass.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Book+CoreDataProperties.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Shelf+CoreDataClass.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Shelf+CoreDataProperties.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/ShelfMembership+CoreDataClass.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/ShelfMembership+CoreDataProperties.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/ReadingProgress+CoreDataClass.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/ReadingProgress+CoreDataProperties.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Highlight+CoreDataClass.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Highlight+CoreDataProperties.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Bookmark+CoreDataClass.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Bookmark+CoreDataProperties.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/ReadingSession+CoreDataClass.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/ReadingSession+CoreDataProperties.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/EpubReader+CoreDataModel.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/GeneratedAssetSymbols.swift -target arm64-apple-ios17.0-simulator -module-can-import-version DeveloperToolsSupport 23.0.4 23.0.4 -module-can-import-version SwiftUI 7.1.13.1 7.1.13 -module-can-import-version UIKit 9126.1.12.1 9126.1.12 -disable-cross-import-overlay-search -swift-module-cross-import CoreData /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/System/Library/Frameworks/CoreData.framework/Modules/CoreData.swiftcrossimport/CloudKit.swiftoverlay -swift-module-cross-import CoreData /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk/System/Library/Frameworks/CoreData.framework/Modules/CoreData.swiftcrossimport/CloudKit.swiftoverlay -swift-module-cross-import WebKit /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/System/Cryptexes/OS/System/Library/Frameworks/WebKit.framework/Modules/WebKit.swiftcrossimport/SwiftUI.swiftoverlay -swift-module-cross-import WebKit /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk/System/Library/Frameworks/WebKit.framework/Modules/WebKit.swiftcrossimport/SwiftUI.swiftoverlay -load-resolved-plugin /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/lib/swift/host/plugins/libFoundationMacros.dylib\#/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/swift-plugin-server\#FoundationMacros -load-resolved-plugin /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/lib/swift/host/plugins/libObservationMacros.dylib\#/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/swift-plugin-server\#ObservationMacros -load-resolved-plugin /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/lib/swift/host/plugins/libPreviewsMacros.dylib\#/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/swift-plugin-server\#PreviewsMacros -load-resolved-plugin /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/lib/swift/host/plugins/libSwiftMacros.dylib\#/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/swift-plugin-server\#SwiftMacros -load-resolved-plugin /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/lib/swift/host/plugins/libSwiftUIMacros.dylib\#/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/swift-plugin-server\#SwiftUIMacros -disable-implicit-swift-modules -Xcc -fno-implicit-modules -Xcc -fno-implicit-module-maps -explicit-swift-module-map-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader-dependencies-28.json -Xllvm -aarch64-use-tbi -enable-objc-interop -sdk /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk -I /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator -F /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/PackageFrameworks -F /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/PackageFrameworks -F /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator -no-color-diagnostics -Xcc -fno-color-diagnostics -enable-testing -g -debug-info-format\=dwarf -dwarf-version\=4 -module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/SwiftExplicitPrecompiledModules -swift-version 6 -enforce-exclusivity\=checked -Onone -D DEBUG -serialize-debugging-options -const-gather-protocols-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader_const_extract_protocols.json -enable-experimental-feature DebugDescriptionMacro -empty-abi-descriptor -validate-clang-modules-once -clang-build-session-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Session.modulevalidation -Xcc -working-directory -Xcc /Users/noamsadi/A-Pub -enable-anonymous-context-mangled-names -file-compilation-dir /Users/noamsadi/A-Pub -Xcc -fmodule-map-file\=/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/Sources/GRDBSQLite/module.modulemap -Xcc -D_LIBCPP_HARDENING_MODE\=_LIBCPP_HARDENING_MODE_DEBUG -Xcc -ivfsstatcache -Xcc /Users/noamsadi/Library/Developer/Xcode/DerivedData/SDKStatCaches.noindex/iphonesimulator26.1-23B77-3885c01c3e6b6a337905948deab2002e90cf18a4295e390e64c810bc6bd7acbc.sdkstatcache -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/swift-overrides.hmap -Xcc -iquote -Xcc /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-generated-files.hmap -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-own-target-headers.hmap -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-all-non-framework-target-headers.hmap -Xcc -ivfsoverlay -Xcc /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader-4d5c3879ad9b5d9dced6c7c32c3b37ba-VFS-iphonesimulator/all-product-headers.yaml -Xcc -iquote -Xcc /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-project-headers.hmap -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/include -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources-normal/arm64 -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/arm64 -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources -Xcc -DDEBUG\=1 -no-auto-bridging-header-chaining -module-name EpubReader -frontend-parseable-output -disable-clang-spi -target-sdk-version 26.1 -target-sdk-name iphonesimulator26.1 -clang-target arm64-apple-ios26.1-simulator -in-process-plugin-server-path /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/host/libSwiftInProcPluginServer.dylib -emit-module-doc-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader.swiftdoc -emit-module-source-info-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader.swiftsourceinfo -emit-objc-header-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader-Swift.h -serialize-diagnostics-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader-primary-emit-module.dia -emit-dependencies-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader-primary-emit-module.d -o /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader.swiftmodule -emit-abi-descriptor-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader.abi.json

EmitSwiftModule normal arm64 (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

/Users/noamsadi/A-Pub/EpubReader/Core/Models/Book.swift:16:9: error: invalid redeclaration of 'appearanceOverride'
    var appearanceOverride: String? {
        ^
/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Book+CoreDataProperties.swift:33:27: note: 'appearanceOverride' previously declared here
    @NSManaged public var appearanceOverride: String?
                          ^
/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Book+CoreDataProperties.swift:33:27: note: 'appearanceOverride' previously declared here
    @NSManaged public var appearanceOverride: String?
                          ^
/Users/noamsadi/A-Pub/EpubReader/Core/Models/Book.swift:21:9: error: invalid redeclaration of 'locationsCache'
    var locationsCache: String? {
        ^
/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Book+CoreDataProperties.swift:34:27: note: 'locationsCache' previously declared here
    @NSManaged public var locationsCache: String?
                          ^
/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Book+CoreDataProperties.swift:34:27: note: 'locationsCache' previously declared here
    @NSManaged public var locationsCache: String?
                          ^

/Users/noamsadi/A-Pub/EpubReader/Core/Models/Book.swift:16:9: Invalid redeclaration of 'appearanceOverride'

/Users/noamsadi/A-Pub/EpubReader/Core/Models/Book.swift:21:9: Invalid redeclaration of 'locationsCache'

SwiftCompile normal arm64 Compiling\ AppEntry.swift,\ Logger.swift,\ EPUBExtractor.swift,\ EPUBChapter.swift,\ EPUBBook.swift,\ EPUBParser.swift /Users/noamsadi/A-Pub/EpubReader/App/AppEntry.swift /Users/noamsadi/A-Pub/EpubReader/Core/Utilities/Logger.swift /Users/noamsadi/A-Pub/EpubReader/Core/EPUB/EPUBExtractor.swift /Users/noamsadi/A-Pub/EpubReader/Core/EPUB/EPUBChapter.swift /Users/noamsadi/A-Pub/EpubReader/Core/EPUB/EPUBBook.swift /Users/noamsadi/A-Pub/EpubReader/Core/EPUB/EPUBParser.swift (in target 'EpubReader' from project 'EpubReader')

SwiftCompile normal arm64 /Users/noamsadi/A-Pub/EpubReader/App/AppEntry.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftCompile normal arm64 /Users/noamsadi/A-Pub/EpubReader/Core/Utilities/Logger.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftCompile normal arm64 /Users/noamsadi/A-Pub/EpubReader/Core/EPUB/EPUBExtractor.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftCompile normal arm64 /Users/noamsadi/A-Pub/EpubReader/Core/EPUB/EPUBChapter.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftCompile normal arm64 /Users/noamsadi/A-Pub/EpubReader/Core/EPUB/EPUBBook.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftCompile normal arm64 /Users/noamsadi/A-Pub/EpubReader/Core/EPUB/EPUBParser.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftCompile normal arm64 Compiling\ ReadingProgress+CoreDataClass.swift,\ ReadingProgress+CoreDataProperties.swift,\ Highlight+CoreDataClass.swift,\ Highlight+CoreDataProperties.swift,\ Bookmark+CoreDataClass.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/ReadingProgress+CoreDataClass.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/ReadingProgress+CoreDataProperties.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Highlight+CoreDataClass.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Highlight+CoreDataProperties.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Bookmark+CoreDataClass.swift (in target 'EpubReader' from project 'EpubReader')

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/ReadingProgress+CoreDataClass.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/ReadingProgress+CoreDataProperties.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Highlight+CoreDataClass.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Highlight+CoreDataProperties.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Bookmark+CoreDataClass.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftCompile normal arm64 Compiling\ Book+CoreDataProperties.swift,\ Shelf+CoreDataClass.swift,\ Shelf+CoreDataProperties.swift,\ ShelfMembership+CoreDataClass.swift,\ ShelfMembership+CoreDataProperties.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Book+CoreDataProperties.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Shelf+CoreDataClass.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Shelf+CoreDataProperties.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/ShelfMembership+CoreDataClass.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/ShelfMembership+CoreDataProperties.swift (in target 'EpubReader' from project 'EpubReader')

Failed frontend command:
/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift-frontend -frontend -c /Users/noamsadi/A-Pub/EpubReader/App/AppEntry.swift /Users/noamsadi/A-Pub/EpubReader/Core/Utilities/Logger.swift /Users/noamsadi/A-Pub/EpubReader/Core/EPUB/EPUBExtractor.swift /Users/noamsadi/A-Pub/EpubReader/Core/EPUB/EPUBChapter.swift /Users/noamsadi/A-Pub/EpubReader/Core/EPUB/EPUBBook.swift /Users/noamsadi/A-Pub/EpubReader/Core/EPUB/EPUBParser.swift /Users/noamsadi/A-Pub/EpubReader/Core/Utilities/LeakAvoider.swift /Users/noamsadi/A-Pub/EpubReader/Features/Reader/EPUBBridge.swift /Users/noamsadi/A-Pub/EpubReader/Features/Reader/EPUBWebView.swift /Users/noamsadi/A-Pub/EpubReader/Core/Utilities/FileImporter.swift /Users/noamsadi/A-Pub/EpubReader/Features/Reader/ReaderView.swift /Users/noamsadi/A-Pub/EpubReader/Features/Reader/ReaderViewModel.swift /Users/noamsadi/A-Pub/EpubReader/Core/Persistence/PersistenceController.swift /Users/noamsadi/A-Pub/EpubReader/Core/Utilities/MetadataExtractor.swift /Users/noamsadi/A-Pub/EpubReader/Core/Utilities/CoverImageExtractor.swift /Users/noamsadi/A-Pub/EpubReader/Features/Library/LibraryView.swift /Users/noamsadi/A-Pub/EpubReader/Features/Library/LibraryViewModel.swift /Users/noamsadi/A-Pub/EpubReader/Features/Library/BookGridCell.swift /Users/noamsadi/A-Pub/EpubReader/Features/Library/BookListCell.swift /Users/noamsadi/A-Pub/EpubReader/Features/Library/BookDetailView.swift /Users/noamsadi/A-Pub/EpubReader/Features/Library/ShelfView.swift /Users/noamsadi/A-Pub/EpubReader/Features/Reader/PageController.swift /Users/noamsadi/A-Pub/EpubReader/Features/Reader/PageCurlViewController.swift /Users/noamsadi/A-Pub/EpubReader/Features/Reader/ReaderSettings.swift /Users/noamsadi/A-Pub/EpubReader/Features/Settings/AppearanceSettings.swift /Users/noamsadi/A-Pub/EpubReader/Core/Models/Book.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Book+CoreDataClass.swift -primary-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Book+CoreDataProperties.swift -primary-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Shelf+CoreDataClass.swift -primary-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Shelf+CoreDataProperties.swift -primary-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/ShelfMembership+CoreDataClass.swift -primary-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/ShelfMembership+CoreDataProperties.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/ReadingProgress+CoreDataClass.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/ReadingProgress+CoreDataProperties.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Highlight+CoreDataClass.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Highlight+CoreDataProperties.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Bookmark+CoreDataClass.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Bookmark+CoreDataProperties.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/ReadingSession+CoreDataClass.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/ReadingSession+CoreDataProperties.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/EpubReader+CoreDataModel.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/GeneratedAssetSymbols.swift -supplementary-output-file-map /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/supplementaryOutputs-191 -emit-localized-strings -emit-localized-strings-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64 -target arm64-apple-ios17.0-simulator -module-can-import-version DeveloperToolsSupport 23.0.4 23.0.4 -module-can-import-version SwiftUI 7.1.13.1 7.1.13 -module-can-import-version UIKit 9126.1.12.1 9126.1.12 -disable-cross-import-overlay-search -swift-module-cross-import CoreData /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/System/Library/Frameworks/CoreData.framework/Modules/CoreData.swiftcrossimport/CloudKit.swiftoverlay -swift-module-cross-import CoreData /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk/System/Library/Frameworks/CoreData.framework/Modules/CoreData.swiftcrossimport/CloudKit.swiftoverlay -swift-module-cross-import WebKit /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/System/Cryptexes/OS/System/Library/Frameworks/WebKit.framework/Modules/WebKit.swiftcrossimport/SwiftUI.swiftoverlay -swift-module-cross-import WebKit /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk/System/Library/Frameworks/WebKit.framework/Modules/WebKit.swiftcrossimport/SwiftUI.swiftoverlay -load-resolved-plugin /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/lib/swift/host/plugins/libFoundationMacros.dylib\#/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/swift-plugin-server\#FoundationMacros -load-resolved-plugin /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/lib/swift/host/plugins/libObservationMacros.dylib\#/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/swift-plugin-server\#ObservationMacros -load-resolved-plugin /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/lib/swift/host/plugins/libPreviewsMacros.dylib\#/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/swift-plugin-server\#PreviewsMacros -load-resolved-plugin /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/lib/swift/host/plugins/libSwiftMacros.dylib\#/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/swift-plugin-server\#SwiftMacros -load-resolved-plugin /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/lib/swift/host/plugins/libSwiftUIMacros.dylib\#/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/swift-plugin-server\#SwiftUIMacros -disable-implicit-swift-modules -Xcc -fno-implicit-modules -Xcc -fno-implicit-module-maps -explicit-swift-module-map-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader-dependencies-28.json -Xllvm -aarch64-use-tbi -enable-objc-interop -sdk /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk -I /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator -F /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/PackageFrameworks -F /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/PackageFrameworks -F /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator -no-color-diagnostics -Xcc -fno-color-diagnostics -enable-testing -g -debug-info-format\=dwarf -dwarf-version\=4 -module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/SwiftExplicitPrecompiledModules -swift-version 6 -enforce-exclusivity\=checked -Onone -D DEBUG -serialize-debugging-options -const-gather-protocols-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader_const_extract_protocols.json -enable-experimental-feature DebugDescriptionMacro -empty-abi-descriptor -validate-clang-modules-once -clang-build-session-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Session.modulevalidation -Xcc -working-directory -Xcc /Users/noamsadi/A-Pub -enable-anonymous-context-mangled-names -file-compilation-dir /Users/noamsadi/A-Pub -Xcc -fmodule-map-file\=/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/Sources/GRDBSQLite/module.modulemap -Xcc -D_LIBCPP_HARDENING_MODE\=_LIBCPP_HARDENING_MODE_DEBUG -Xcc -ivfsstatcache -Xcc /Users/noamsadi/Library/Developer/Xcode/DerivedData/SDKStatCaches.noindex/iphonesimulator26.1-23B77-3885c01c3e6b6a337905948deab2002e90cf18a4295e390e64c810bc6bd7acbc.sdkstatcache -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/swift-overrides.hmap -Xcc -iquote -Xcc /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-generated-files.hmap -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-own-target-headers.hmap -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-all-non-framework-target-headers.hmap -Xcc -ivfsoverlay -Xcc /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader-4d5c3879ad9b5d9dced6c7c32c3b37ba-VFS-iphonesimulator/all-product-headers.yaml -Xcc -iquote -Xcc /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-project-headers.hmap -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/include -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources-normal/arm64 -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/arm64 -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources -Xcc -DDEBUG\=1 -no-auto-bridging-header-chaining -module-name EpubReader -frontend-parseable-output -disable-clang-spi -target-sdk-version 26.1 -target-sdk-name iphonesimulator26.1 -clang-target arm64-apple-ios26.1-simulator -in-process-plugin-server-path /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/host/libSwiftInProcPluginServer.dylib -o /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/Book+CoreDataProperties.o -o /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/Shelf+CoreDataClass.o -o /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/Shelf+CoreDataProperties.o -o /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/ShelfMembership+CoreDataClass.o -o /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/ShelfMembership+CoreDataProperties.o -index-unit-output-path /EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/Book+CoreDataProperties.o -index-unit-output-path /EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/Shelf+CoreDataClass.o -index-unit-output-path /EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/Shelf+CoreDataProperties.o -index-unit-output-path /EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/ShelfMembership+CoreDataClass.o -index-unit-output-path /EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/ShelfMembership+CoreDataProperties.o -index-store-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Index.noindex/DataStore -index-system-modules

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Book+CoreDataProperties.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Book+CoreDataProperties.swift:33:27: error: invalid redeclaration of 'appearanceOverride'
    @NSManaged public var appearanceOverride: String?
                          ^
/Users/noamsadi/A-Pub/EpubReader/Core/Models/Book.swift:16:9: note: 'appearanceOverride' previously declared here
    var appearanceOverride: String? {
        ^
/Users/noamsadi/A-Pub/EpubReader/Core/Models/Book.swift:16:9: note: 'appearanceOverride' previously declared here
    var appearanceOverride: String? {
        ^
/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Book+CoreDataProperties.swift:34:27: error: invalid redeclaration of 'locationsCache'
    @NSManaged public var locationsCache: String?
                          ^
/Users/noamsadi/A-Pub/EpubReader/Core/Models/Book.swift:21:9: note: 'locationsCache' previously declared here
    var locationsCache: String? {
        ^
/Users/noamsadi/A-Pub/EpubReader/Core/Models/Book.swift:21:9: note: 'locationsCache' previously declared here
    var locationsCache: String? {
        ^

/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Book+CoreDataProperties.swift:33:27: Invalid redeclaration of 'appearanceOverride'

/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Book+CoreDataProperties.swift:34:27: Invalid redeclaration of 'locationsCache'

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Shelf+CoreDataClass.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Shelf+CoreDataProperties.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/ShelfMembership+CoreDataClass.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/ShelfMembership+CoreDataProperties.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftCompile normal arm64 Compiling\ PageCurlViewController.swift,\ ReaderSettings.swift,\ AppearanceSettings.swift,\ Book.swift,\ Book+CoreDataClass.swift /Users/noamsadi/A-Pub/EpubReader/Features/Reader/PageCurlViewController.swift /Users/noamsadi/A-Pub/EpubReader/Features/Reader/ReaderSettings.swift /Users/noamsadi/A-Pub/EpubReader/Features/Settings/AppearanceSettings.swift /Users/noamsadi/A-Pub/EpubReader/Core/Models/Book.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Book+CoreDataClass.swift (in target 'EpubReader' from project 'EpubReader')

Internal Error: dataCorrupted(Swift.DecodingError.Context(codingPath: [], debugDescription: "Corrupted JSON", underlyingError: Optional(unexpected end of file)))
Failed frontend command:
/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift-frontend -frontend -c /Users/noamsadi/A-Pub/EpubReader/App/AppEntry.swift /Users/noamsadi/A-Pub/EpubReader/Core/Utilities/Logger.swift /Users/noamsadi/A-Pub/EpubReader/Core/EPUB/EPUBExtractor.swift /Users/noamsadi/A-Pub/EpubReader/Core/EPUB/EPUBChapter.swift /Users/noamsadi/A-Pub/EpubReader/Core/EPUB/EPUBBook.swift /Users/noamsadi/A-Pub/EpubReader/Core/EPUB/EPUBParser.swift /Users/noamsadi/A-Pub/EpubReader/Core/Utilities/LeakAvoider.swift /Users/noamsadi/A-Pub/EpubReader/Features/Reader/EPUBBridge.swift /Users/noamsadi/A-Pub/EpubReader/Features/Reader/EPUBWebView.swift /Users/noamsadi/A-Pub/EpubReader/Core/Utilities/FileImporter.swift /Users/noamsadi/A-Pub/EpubReader/Features/Reader/ReaderView.swift /Users/noamsadi/A-Pub/EpubReader/Features/Reader/ReaderViewModel.swift /Users/noamsadi/A-Pub/EpubReader/Core/Persistence/PersistenceController.swift /Users/noamsadi/A-Pub/EpubReader/Core/Utilities/MetadataExtractor.swift /Users/noamsadi/A-Pub/EpubReader/Core/Utilities/CoverImageExtractor.swift /Users/noamsadi/A-Pub/EpubReader/Features/Library/LibraryView.swift /Users/noamsadi/A-Pub/EpubReader/Features/Library/LibraryViewModel.swift /Users/noamsadi/A-Pub/EpubReader/Features/Library/BookGridCell.swift /Users/noamsadi/A-Pub/EpubReader/Features/Library/BookListCell.swift /Users/noamsadi/A-Pub/EpubReader/Features/Library/BookDetailView.swift /Users/noamsadi/A-Pub/EpubReader/Features/Library/ShelfView.swift /Users/noamsadi/A-Pub/EpubReader/Features/Reader/PageController.swift -primary-file /Users/noamsadi/A-Pub/EpubReader/Features/Reader/PageCurlViewController.swift -primary-file /Users/noamsadi/A-Pub/EpubReader/Features/Reader/ReaderSettings.swift -primary-file /Users/noamsadi/A-Pub/EpubReader/Features/Settings/AppearanceSettings.swift -primary-file /Users/noamsadi/A-Pub/EpubReader/Core/Models/Book.swift -primary-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Book+CoreDataClass.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Book+CoreDataProperties.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Shelf+CoreDataClass.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Shelf+CoreDataProperties.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/ShelfMembership+CoreDataClass.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/ShelfMembership+CoreDataProperties.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/ReadingProgress+CoreDataClass.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/ReadingProgress+CoreDataProperties.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Highlight+CoreDataClass.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Highlight+CoreDataProperties.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Bookmark+CoreDataClass.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Bookmark+CoreDataProperties.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/ReadingSession+CoreDataClass.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/ReadingSession+CoreDataProperties.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/EpubReader+CoreDataModel.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/GeneratedAssetSymbols.swift -supplementary-output-file-map /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/supplementaryOutputs-190 -emit-localized-strings -emit-localized-strings-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64 -target arm64-apple-ios17.0-simulator -module-can-import-version DeveloperToolsSupport 23.0.4 23.0.4 -module-can-import-version SwiftUI 7.1.13.1 7.1.13 -module-can-import-version UIKit 9126.1.12.1 9126.1.12 -disable-cross-import-overlay-search -swift-module-cross-import CoreData /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/System/Library/Frameworks/CoreData.framework/Modules/CoreData.swiftcrossimport/CloudKit.swiftoverlay -swift-module-cross-import CoreData /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk/System/Library/Frameworks/CoreData.framework/Modules/CoreData.swiftcrossimport/CloudKit.swiftoverlay -swift-module-cross-import WebKit /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/System/Cryptexes/OS/System/Library/Frameworks/WebKit.framework/Modules/WebKit.swiftcrossimport/SwiftUI.swiftoverlay -swift-module-cross-import WebKit /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk/System/Library/Frameworks/WebKit.framework/Modules/WebKit.swiftcrossimport/SwiftUI.swiftoverlay -load-resolved-plugin /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/lib/swift/host/plugins/libFoundationMacros.dylib\#/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/swift-plugin-server\#FoundationMacros -load-resolved-plugin /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/lib/swift/host/plugins/libObservationMacros.dylib\#/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/swift-plugin-server\#ObservationMacros -load-resolved-plugin /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/lib/swift/host/plugins/libPreviewsMacros.dylib\#/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/swift-plugin-server\#PreviewsMacros -load-resolved-plugin /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/lib/swift/host/plugins/libSwiftMacros.dylib\#/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/swift-plugin-server\#SwiftMacros -load-resolved-plugin /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/lib/swift/host/plugins/libSwiftUIMacros.dylib\#/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/swift-plugin-server\#SwiftUIMacros -disable-implicit-swift-modules -Xcc -fno-implicit-modules -Xcc -fno-implicit-module-maps -explicit-swift-module-map-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader-dependencies-28.json -Xllvm -aarch64-use-tbi -enable-objc-interop -sdk /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk -I /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator -F /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/PackageFrameworks -F /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/PackageFrameworks -F /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator -no-color-diagnostics -Xcc -fno-color-diagnostics -enable-testing -g -debug-info-format\=dwarf -dwarf-version\=4 -module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/SwiftExplicitPrecompiledModules -swift-version 6 -enforce-exclusivity\=checked -Onone -D DEBUG -serialize-debugging-options -const-gather-protocols-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader_const_extract_protocols.json -enable-experimental-feature DebugDescriptionMacro -empty-abi-descriptor -validate-clang-modules-once -clang-build-session-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Session.modulevalidation -Xcc -working-directory -Xcc /Users/noamsadi/A-Pub -enable-anonymous-context-mangled-names -file-compilation-dir /Users/noamsadi/A-Pub -Xcc -fmodule-map-file\=/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/Sources/GRDBSQLite/module.modulemap -Xcc -D_LIBCPP_HARDENING_MODE\=_LIBCPP_HARDENING_MODE_DEBUG -Xcc -ivfsstatcache -Xcc /Users/noamsadi/Library/Developer/Xcode/DerivedData/SDKStatCaches.noindex/iphonesimulator26.1-23B77-3885c01c3e6b6a337905948deab2002e90cf18a4295e390e64c810bc6bd7acbc.sdkstatcache -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/swift-overrides.hmap -Xcc -iquote -Xcc /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-generated-files.hmap -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-own-target-headers.hmap -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-all-non-framework-target-headers.hmap -Xcc -ivfsoverlay -Xcc /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader-4d5c3879ad9b5d9dced6c7c32c3b37ba-VFS-iphonesimulator/all-product-headers.yaml -Xcc -iquote -Xcc /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-project-headers.hmap -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/include -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources-normal/arm64 -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/arm64 -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources -Xcc -DDEBUG\=1 -no-auto-bridging-header-chaining -module-name EpubReader -frontend-parseable-output -disable-clang-spi -target-sdk-version 26.1 -target-sdk-name iphonesimulator26.1 -clang-target arm64-apple-ios26.1-simulator -in-process-plugin-server-path /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/host/libSwiftInProcPluginServer.dylib -o /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/PageCurlViewController.o -o /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/ReaderSettings.o -o /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/AppearanceSettings.o -o /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/Book.o -o /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/Book+CoreDataClass.o -index-unit-output-path /EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/PageCurlViewController.o -index-unit-output-path /EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/ReaderSettings.o -index-unit-output-path /EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/AppearanceSettings.o -index-unit-output-path /EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/Book.o -index-unit-output-path /EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/Book+CoreDataClass.o -index-store-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Index.noindex/DataStore -index-system-modules

SwiftCompile normal arm64 /Users/noamsadi/A-Pub/EpubReader/Features/Reader/PageCurlViewController.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftCompile normal arm64 /Users/noamsadi/A-Pub/EpubReader/Features/Reader/ReaderSettings.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftCompile normal arm64 /Users/noamsadi/A-Pub/EpubReader/Features/Settings/AppearanceSettings.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftCompile normal arm64 /Users/noamsadi/A-Pub/EpubReader/Core/Models/Book.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

/Users/noamsadi/A-Pub/EpubReader/Core/Models/Book.swift:16:9: error: invalid redeclaration of 'appearanceOverride'
    var appearanceOverride: String? {
        ^
/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Book+CoreDataProperties.swift:33:27: note: 'appearanceOverride' previously declared here
    @NSManaged public var appearanceOverride: String?
                          ^
/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Book+CoreDataProperties.swift:33:27: note: 'appearanceOverride' previously declared here
    @NSManaged public var appearanceOverride: String?
                          ^
/Users/noamsadi/A-Pub/EpubReader/Core/Models/Book.swift:21:9: error: invalid redeclaration of 'locationsCache'
    var locationsCache: String? {
        ^
/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Book+CoreDataProperties.swift:34:27: note: 'locationsCache' previously declared here
    @NSManaged public var locationsCache: String?
                          ^
/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Book+CoreDataProperties.swift:34:27: note: 'locationsCache' previously declared here
    @NSManaged public var locationsCache: String?
                          ^
/Users/noamsadi/A-Pub/EpubReader/Core/Models/Book.swift:35:20: error: call to main actor-isolated initializer 'init(payload:)' in a synchronous nonisolated context
            return ReaderAppearance(payload: payload)
                   ^
/Users/noamsadi/A-Pub/EpubReader/Core/Models/Book.swift:63:29: note: calls to initializer 'init(payload:)' from outside of its actor context are implicitly asynchronous
    fileprivate convenience init(payload: ReaderAppearanceOverridePayload) {
                            ^
/Users/noamsadi/A-Pub/EpubReader/Core/Models/Book.swift:44:36: error: main actor-isolated property 'fontFamily' can not be referenced from a nonisolated context
            fontFamily: appearance.fontFamily,
                                   ^
/Users/noamsadi/A-Pub/EpubReader/Features/Reader/ReaderSettings.swift:13:9: note: property declared here
    var fontFamily: String {
        ^
/Users/noamsadi/A-Pub/EpubReader/Core/Models/Book.swift:45:34: error: main actor-isolated property 'fontSize' can not be referenced from a nonisolated context
            fontSize: appearance.fontSize,
                                 ^
/Users/noamsadi/A-Pub/EpubReader/Features/Reader/ReaderSettings.swift:17:9: note: property declared here
    var fontSize: Double {
        ^
/Users/noamsadi/A-Pub/EpubReader/Core/Models/Book.swift:46:31: error: main actor-isolated property 'theme' can not be referenced from a nonisolated context
            theme: appearance.theme,
                              ^
/Users/noamsadi/A-Pub/EpubReader/Features/Reader/ReaderSettings.swift:21:9: note: property declared here
    var theme: String {
        ^
/Users/noamsadi/A-Pub/EpubReader/Core/Models/Book.swift:47:37: error: main actor-isolated property 'lineSpacing' can not be referenced from a nonisolated context
            lineSpacing: appearance.lineSpacing,
                                    ^
/Users/noamsadi/A-Pub/EpubReader/Features/Reader/ReaderSettings.swift:25:9: note: property declared here
    var lineSpacing: Double {
        ^
/Users/noamsadi/A-Pub/EpubReader/Core/Models/Book.swift:48:37: error: main actor-isolated property 'marginStyle' can not be referenced from a nonisolated context
            marginStyle: appearance.marginStyle,
                                    ^
/Users/noamsadi/A-Pub/EpubReader/Features/Reader/ReaderSettings.swift:29:9: note: property declared here
    var marginStyle: String {
        ^
/Users/noamsadi/A-Pub/EpubReader/Core/Models/Book.swift:49:39: error: main actor-isolated property 'textAlignment' can not be referenced from a nonisolated context
            textAlignment: appearance.textAlignment,
                                      ^
/Users/noamsadi/A-Pub/EpubReader/Features/Reader/ReaderSettings.swift:33:9: note: property declared here
    var textAlignment: String {
        ^
/Users/noamsadi/A-Pub/EpubReader/Core/Models/Book.swift:50:37: error: main actor-isolated property 'hyphenation' can not be referenced from a nonisolated context
            hyphenation: appearance.hyphenation
                                    ^
/Users/noamsadi/A-Pub/EpubReader/Features/Reader/ReaderSettings.swift:37:9: note: property declared here
    var hyphenation: Bool {
        ^

/Users/noamsadi/A-Pub/EpubReader/Core/Models/Book.swift:16:9: Invalid redeclaration of 'appearanceOverride'

/Users/noamsadi/A-Pub/EpubReader/Core/Models/Book.swift:21:9: Invalid redeclaration of 'locationsCache'

/Users/noamsadi/A-Pub/EpubReader/Core/Models/Book.swift:35:20: Call to main actor-isolated initializer 'init(payload:)' in a synchronous nonisolated context

/Users/noamsadi/A-Pub/EpubReader/Core/Models/Book.swift:44:36: Main actor-isolated property 'fontFamily' can not be referenced from a nonisolated context

/Users/noamsadi/A-Pub/EpubReader/Core/Models/Book.swift:45:34: Main actor-isolated property 'fontSize' can not be referenced from a nonisolated context

/Users/noamsadi/A-Pub/EpubReader/Core/Models/Book.swift:46:31: Main actor-isolated property 'theme' can not be referenced from a nonisolated context

/Users/noamsadi/A-Pub/EpubReader/Core/Models/Book.swift:47:37: Main actor-isolated property 'lineSpacing' can not be referenced from a nonisolated context

/Users/noamsadi/A-Pub/EpubReader/Core/Models/Book.swift:48:37: Main actor-isolated property 'marginStyle' can not be referenced from a nonisolated context

/Users/noamsadi/A-Pub/EpubReader/Core/Models/Book.swift:49:39: Main actor-isolated property 'textAlignment' can not be referenced from a nonisolated context

/Users/noamsadi/A-Pub/EpubReader/Core/Models/Book.swift:50:37: Main actor-isolated property 'hyphenation' can not be referenced from a nonisolated context

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Book+CoreDataClass.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftCompile normal arm64 Compiling\ PersistenceController.swift,\ MetadataExtractor.swift,\ CoverImageExtractor.swift,\ LibraryView.swift,\ LibraryViewModel.swift /Users/noamsadi/A-Pub/EpubReader/Core/Persistence/PersistenceController.swift /Users/noamsadi/A-Pub/EpubReader/Core/Utilities/MetadataExtractor.swift /Users/noamsadi/A-Pub/EpubReader/Core/Utilities/CoverImageExtractor.swift /Users/noamsadi/A-Pub/EpubReader/Features/Library/LibraryView.swift /Users/noamsadi/A-Pub/EpubReader/Features/Library/LibraryViewModel.swift (in target 'EpubReader' from project 'EpubReader')

SwiftCompile normal arm64 /Users/noamsadi/A-Pub/EpubReader/Core/Persistence/PersistenceController.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftCompile normal arm64 /Users/noamsadi/A-Pub/EpubReader/Core/Utilities/MetadataExtractor.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftCompile normal arm64 /Users/noamsadi/A-Pub/EpubReader/Core/Utilities/CoverImageExtractor.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftCompile normal arm64 /Users/noamsadi/A-Pub/EpubReader/Features/Library/LibraryView.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftCompile normal arm64 /Users/noamsadi/A-Pub/EpubReader/Features/Library/LibraryViewModel.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftCompile normal arm64 Compiling\ BookGridCell.swift,\ BookListCell.swift,\ BookDetailView.swift,\ ShelfView.swift,\ PageController.swift /Users/noamsadi/A-Pub/EpubReader/Features/Library/BookGridCell.swift /Users/noamsadi/A-Pub/EpubReader/Features/Library/BookListCell.swift /Users/noamsadi/A-Pub/EpubReader/Features/Library/BookDetailView.swift /Users/noamsadi/A-Pub/EpubReader/Features/Library/ShelfView.swift /Users/noamsadi/A-Pub/EpubReader/Features/Reader/PageController.swift (in target 'EpubReader' from project 'EpubReader')

SwiftCompile normal arm64 /Users/noamsadi/A-Pub/EpubReader/Features/Library/BookGridCell.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftCompile normal arm64 /Users/noamsadi/A-Pub/EpubReader/Features/Library/BookListCell.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftCompile normal arm64 /Users/noamsadi/A-Pub/EpubReader/Features/Library/BookDetailView.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftCompile normal arm64 /Users/noamsadi/A-Pub/EpubReader/Features/Library/ShelfView.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftCompile normal arm64 /Users/noamsadi/A-Pub/EpubReader/Features/Reader/PageController.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftCompile normal arm64 Compiling\ Bookmark+CoreDataProperties.swift,\ ReadingSession+CoreDataClass.swift,\ ReadingSession+CoreDataProperties.swift,\ EpubReader+CoreDataModel.swift,\ GeneratedAssetSymbols.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Bookmark+CoreDataProperties.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/ReadingSession+CoreDataClass.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/ReadingSession+CoreDataProperties.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/EpubReader+CoreDataModel.swift /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/GeneratedAssetSymbols.swift (in target 'EpubReader' from project 'EpubReader')

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/Bookmark+CoreDataProperties.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/ReadingSession+CoreDataClass.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/ReadingSession+CoreDataProperties.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/CoreDataGenerated/EpubReader/EpubReader+CoreDataModel.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftCompile normal arm64 /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/GeneratedAssetSymbols.swift (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    

SwiftDriver\ Compilation\ Requirements EpubReader normal arm64 com.apple.xcode.tools.swift.compiler (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    builtin-Swift-Compilation-Requirements -- /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swiftc -module-name EpubReader -Onone -enforce-exclusivity\=checked @/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader.SwiftFileList -DDEBUG -Xcc -fmodule-map-file\=/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/Sources/GRDBSQLite/module.modulemap -enable-experimental-feature DebugDescriptionMacro -sdk /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk -target arm64-apple-ios17.0-simulator -g -module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex -Xfrontend -serialize-debugging-options -enable-testing -index-store-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Index.noindex/DataStore -Xcc -D_LIBCPP_HARDENING_MODE\=_LIBCPP_HARDENING_MODE_DEBUG -swift-version 6 -I /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator -F /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/PackageFrameworks -F /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/PackageFrameworks -F /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator -emit-localized-strings -emit-localized-strings-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64 -c -j8 -enable-batch-mode -incremental -Xcc -ivfsstatcache -Xcc /Users/noamsadi/Library/Developer/Xcode/DerivedData/SDKStatCaches.noindex/iphonesimulator26.1-23B77-3885c01c3e6b6a337905948deab2002e90cf18a4295e390e64c810bc6bd7acbc.sdkstatcache -output-file-map /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader-OutputFileMap.json -use-frontend-parseable-output -save-temps -no-color-diagnostics -explicit-module-build -module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/SwiftExplicitPrecompiledModules -clang-scanner-module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex -sdk-module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex -serialize-diagnostics -emit-dependencies -emit-module -emit-module-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader.swiftmodule -validate-clang-modules-once -clang-build-session-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Session.modulevalidation -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/swift-overrides.hmap -emit-const-values -Xfrontend -const-gather-protocols-file -Xfrontend /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader_const_extract_protocols.json -Xcc -iquote -Xcc /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-generated-files.hmap -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-own-target-headers.hmap -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-all-non-framework-target-headers.hmap -Xcc -ivfsoverlay -Xcc /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader-4d5c3879ad9b5d9dced6c7c32c3b37ba-VFS-iphonesimulator/all-product-headers.yaml -Xcc -iquote -Xcc /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-project-headers.hmap -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/include -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources-normal/arm64 -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/arm64 -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources -Xcc -DDEBUG\=1 -emit-objc-header -emit-objc-header-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader-Swift.h -working-directory /Users/noamsadi/A-Pub -experimental-emit-module-separately -disable-cmo

Copy /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.swiftmodule/arm64-apple-ios-simulator.swiftmodule /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader.swiftmodule (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    builtin-copy -exclude .DS_Store -exclude CVS -exclude .svn -exclude .git -exclude .hg -resolve-src-symlinks -rename /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader.swiftmodule /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.swiftmodule/arm64-apple-ios-simulator.swiftmodule

error: lstat(/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader.swiftmodule): No such file or directory (2) (in target 'EpubReader' from project 'EpubReader')

lstat(/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader.swiftmodule): No such file or directory (2)

Copy /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.swiftmodule/arm64-apple-ios-simulator.swiftdoc /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader.swiftdoc (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    builtin-copy -exclude .DS_Store -exclude CVS -exclude .svn -exclude .git -exclude .hg -resolve-src-symlinks -rename /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader.swiftdoc /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.swiftmodule/arm64-apple-ios-simulator.swiftdoc

error: lstat(/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader.swiftdoc): No such file or directory (2) (in target 'EpubReader' from project 'EpubReader')

lstat(/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader.swiftdoc): No such file or directory (2)

Copy /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.swiftmodule/arm64-apple-ios-simulator.abi.json /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader.abi.json (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    builtin-copy -exclude .DS_Store -exclude CVS -exclude .svn -exclude .git -exclude .hg -resolve-src-symlinks -rename /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader.abi.json /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.swiftmodule/arm64-apple-ios-simulator.abi.json

error: lstat(/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader.abi.json): No such file or directory (2) (in target 'EpubReader' from project 'EpubReader')

lstat(/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader.abi.json): No such file or directory (2)

Copy /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.swiftmodule/Project/arm64-apple-ios-simulator.swiftsourceinfo /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader.swiftsourceinfo (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    builtin-copy -exclude .DS_Store -exclude CVS -exclude .svn -exclude .git -exclude .hg -resolve-src-symlinks -rename /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader.swiftsourceinfo /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.swiftmodule/Project/arm64-apple-ios-simulator.swiftsourceinfo

error: lstat(/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader.swiftsourceinfo): No such file or directory (2) (in target 'EpubReader' from project 'EpubReader')

lstat(/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader.swiftsourceinfo): No such file or directory (2)

ValidateDevelopmentAssets /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    builtin-validate-development-assets --validate YES_ERROR /Users/noamsadi/A-Pub/EpubReader/Preview\ Content

CpResource /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app/jszip.min.js /Users/noamsadi/A-Pub/EpubReader/Resources/jszip.min.js (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    builtin-copy -exclude .DS_Store -exclude CVS -exclude .svn -exclude .git -exclude .hg -resolve-src-symlinks /Users/noamsadi/A-Pub/EpubReader/Resources/jszip.min.js /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app

CpResource /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app/reader.html /Users/noamsadi/A-Pub/EpubReader/Resources/reader.html (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    builtin-copy -exclude .DS_Store -exclude CVS -exclude .svn -exclude .git -exclude .hg -resolve-src-symlinks /Users/noamsadi/A-Pub/EpubReader/Resources/reader.html /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app

CpResource /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app/reader.css /Users/noamsadi/A-Pub/EpubReader/Resources/reader.css (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    builtin-copy -exclude .DS_Store -exclude CVS -exclude .svn -exclude .git -exclude .hg -resolve-src-symlinks /Users/noamsadi/A-Pub/EpubReader/Resources/reader.css /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app

Ld /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app/__preview.dylib normal (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -Xlinker -reproducible -target arm64-apple-ios17.0-simulator -dynamiclib -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk -O0 -L/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator -F/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/PackageFrameworks -F/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/PackageFrameworks -F/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator -install_name @rpath/EpubReader.debug.dylib -dead_strip -rdynamic -Xlinker -no_deduplicate -Xlinker -objc_abi_version -Xlinker 2 -Xlinker -dependency_info -Xlinker /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader_dependency_info.dat -Xlinker -sectcreate -Xlinker __TEXT -Xlinker __entitlements -Xlinker /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader.app-Simulated.xcent -Xlinker -sectcreate -Xlinker __TEXT -Xlinker __ents_der -Xlinker /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader.app-Simulated.xcent.der -Xlinker -no_adhoc_codesign -o /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app/__preview.dylib

CpResource /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app/iAWriterQuattroS-Regular.ttf /Users/noamsadi/A-Pub/EpubReader/Resources/Fonts/iAWriterQuattroS-Regular.ttf (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    builtin-copy -exclude .DS_Store -exclude CVS -exclude .svn -exclude .git -exclude .hg -resolve-src-symlinks /Users/noamsadi/A-Pub/EpubReader/Resources/Fonts/iAWriterQuattroS-Regular.ttf /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app

CpResource /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app/iAWriterQuattroS-Italic.ttf /Users/noamsadi/A-Pub/EpubReader/Resources/Fonts/iAWriterQuattroS-Italic.ttf (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    builtin-copy -exclude .DS_Store -exclude CVS -exclude .svn -exclude .git -exclude .hg -resolve-src-symlinks /Users/noamsadi/A-Pub/EpubReader/Resources/Fonts/iAWriterQuattroS-Italic.ttf /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app

CpResource /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app/epub.js /Users/noamsadi/A-Pub/EpubReader/Resources/epub.js (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    builtin-copy -exclude .DS_Store -exclude CVS -exclude .svn -exclude .git -exclude .hg -resolve-src-symlinks /Users/noamsadi/A-Pub/EpubReader/Resources/epub.js /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app

CpResource /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app/Literata-Regular.ttf /Users/noamsadi/A-Pub/EpubReader/Resources/Fonts/Literata-Regular.ttf (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    builtin-copy -exclude .DS_Store -exclude CVS -exclude .svn -exclude .git -exclude .hg -resolve-src-symlinks /Users/noamsadi/A-Pub/EpubReader/Resources/Fonts/Literata-Regular.ttf /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app

CpResource /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app/Literata-Italic.ttf /Users/noamsadi/A-Pub/EpubReader/Resources/Fonts/Literata-Italic.ttf (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    builtin-copy -exclude .DS_Store -exclude CVS -exclude .svn -exclude .git -exclude .hg -resolve-src-symlinks /Users/noamsadi/A-Pub/EpubReader/Resources/Fonts/Literata-Italic.ttf /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app

CpResource /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app/EBGaramond-Regular.ttf /Users/noamsadi/A-Pub/EpubReader/Resources/Fonts/EBGaramond-Regular.ttf (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    builtin-copy -exclude .DS_Store -exclude CVS -exclude .svn -exclude .git -exclude .hg -resolve-src-symlinks /Users/noamsadi/A-Pub/EpubReader/Resources/Fonts/EBGaramond-Regular.ttf /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app

CpResource /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app/EBGaramond-Italic.ttf /Users/noamsadi/A-Pub/EpubReader/Resources/Fonts/EBGaramond-Italic.ttf (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    builtin-copy -exclude .DS_Store -exclude CVS -exclude .svn -exclude .git -exclude .hg -resolve-src-symlinks /Users/noamsadi/A-Pub/EpubReader/Resources/Fonts/EBGaramond-Italic.ttf /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app

Copy /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app/ZIPFoundation_ZIPFoundation.bundle /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/ZIPFoundation_ZIPFoundation.bundle (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    builtin-copy -exclude .DS_Store -exclude CVS -exclude .svn -exclude .git -exclude .hg -resolve-src-symlinks /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/ZIPFoundation_ZIPFoundation.bundle /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app

Copy /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app/GRDB_GRDB.bundle /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/GRDB_GRDB.bundle (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    builtin-copy -exclude .DS_Store -exclude CVS -exclude .svn -exclude .git -exclude .hg -resolve-src-symlinks /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/GRDB_GRDB.bundle /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app

SwiftDriver\ Compilation EpubReader normal arm64 com.apple.xcode.tools.swift.compiler (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    builtin-Swift-Compilation -- /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swiftc -module-name EpubReader -Onone -enforce-exclusivity\=checked @/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader.SwiftFileList -DDEBUG -Xcc -fmodule-map-file\=/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/SourcePackages/checkouts/GRDB.swift/Sources/GRDBSQLite/module.modulemap -enable-experimental-feature DebugDescriptionMacro -sdk /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.1.sdk -target arm64-apple-ios17.0-simulator -g -module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex -Xfrontend -serialize-debugging-options -enable-testing -index-store-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Index.noindex/DataStore -Xcc -D_LIBCPP_HARDENING_MODE\=_LIBCPP_HARDENING_MODE_DEBUG -swift-version 6 -I /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator -F /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/PackageFrameworks -F /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/PackageFrameworks -F /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator -emit-localized-strings -emit-localized-strings-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64 -c -j8 -enable-batch-mode -incremental -Xcc -ivfsstatcache -Xcc /Users/noamsadi/Library/Developer/Xcode/DerivedData/SDKStatCaches.noindex/iphonesimulator26.1-23B77-3885c01c3e6b6a337905948deab2002e90cf18a4295e390e64c810bc6bd7acbc.sdkstatcache -output-file-map /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader-OutputFileMap.json -use-frontend-parseable-output -save-temps -no-color-diagnostics -explicit-module-build -module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/SwiftExplicitPrecompiledModules -clang-scanner-module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex -sdk-module-cache-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex -serialize-diagnostics -emit-dependencies -emit-module -emit-module-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader.swiftmodule -validate-clang-modules-once -clang-build-session-file /Users/noamsadi/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Session.modulevalidation -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/swift-overrides.hmap -emit-const-values -Xfrontend -const-gather-protocols-file -Xfrontend /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader_const_extract_protocols.json -Xcc -iquote -Xcc /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-generated-files.hmap -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-own-target-headers.hmap -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-all-non-framework-target-headers.hmap -Xcc -ivfsoverlay -Xcc /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader-4d5c3879ad9b5d9dced6c7c32c3b37ba-VFS-iphonesimulator/all-product-headers.yaml -Xcc -iquote -Xcc /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/EpubReader-project-headers.hmap -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/include -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources-normal/arm64 -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources/arm64 -Xcc -I/Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/DerivedSources -Xcc -DDEBUG\=1 -emit-objc-header -emit-objc-header-path /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/Objects-normal/arm64/EpubReader-Swift.h -working-directory /Users/noamsadi/A-Pub -experimental-emit-module-separately -disable-cmo

LinkAssetCatalog /Users/noamsadi/A-Pub/EpubReader/Preview\ Content/Preview\ Assets.xcassets /Users/noamsadi/A-Pub/EpubReader/Assets.xcassets (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    builtin-linkAssetCatalog --thinned /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/assetcatalog_output/thinned --thinned-dependencies /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/assetcatalog_dependencies_thinned --thinned-info-plist-content /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/assetcatalog_generated_info.plist_thinned --unthinned /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/assetcatalog_output/unthinned --unthinned-dependencies /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/assetcatalog_dependencies_unthinned --unthinned-info-plist-content /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/assetcatalog_generated_info.plist_unthinned --output /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app --plist-output /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/assetcatalog_generated_info.plist

note: Emplaced /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app/Assets.car (in target 'EpubReader' from project 'EpubReader')

Emplaced /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app/Assets.car

ProcessInfoPlistFile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app/Info.plist /Users/noamsadi/A-Pub/EpubReader/Info.plist (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    builtin-infoPlistUtility /Users/noamsadi/A-Pub/EpubReader/Info.plist -producttype com.apple.product-type.application -genpkginfo /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app/PkgInfo -expandbuildsettings -format binary -platform iphonesimulator -additionalcontentfile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Intermediates.noindex/EpubReader.build/Debug-iphonesimulator/EpubReader.build/assetcatalog_generated_info.plist -scanforprivacyfile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app/GRDB_GRDB.bundle -scanforprivacyfile /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app/ZIPFoundation_ZIPFoundation.bundle -o /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app/Info.plist

RegisterExecutionPolicyException /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    builtin-RegisterExecutionPolicyException /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app

Touch /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app (in target 'EpubReader' from project 'EpubReader')
    cd /Users/noamsadi/A-Pub
    /usr/bin/touch -c /Users/noamsadi/Library/Developer/Xcode/DerivedData/EpubReader-foclqvbtrluvbpasidyamvkythdf/Build/Products/Debug-iphonesimulator/EpubReader.app



Build failed    26/04/2026, 10:43    13.0 seconds
