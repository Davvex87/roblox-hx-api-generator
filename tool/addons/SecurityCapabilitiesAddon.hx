package addons;

import core.Expr;

using core.ExprTools;

class SecurityCapabilitiesAddon implements IAddon
{
	public function new() {}

	public function buildClasses()
	{
		return [];
	}

	public function buildEnums()
	{
		return [
			{
				name: "SecurityCapabilities",
				items: [
					{
						name: "RunClientScript",
						value: 0
					},
					{
						name: "RunServerScript",
						value: 1
					},
					{
						name: "AccessOutsideWrite",
						value: 2
					},
					{
						name: "AssetRequire",
						value: 3
					},
					{
						name: "LoadString",
						value: 4
					},
					{
						name: "ScriptGlobals",
						value: 5
					},
					{
						name: "CreateInstances",
						value: 6
					},
					{
						name: "Basic",
						value: 7
					},
					{
						name: "Audio",
						value: 8
					},
					{
						name: "DataStore",
						value: 9
					},
					{
						name: "Network",
						value: 10
					},
					{
						name: "Physics",
						value: 11
					},
					{
						name: "UI",
						value: 12
					},
					{
						name: "CSG",
						value: 13
					},
					{
						name: "Chat",
						value: 14
					},
					{
						name: "Animation",
						value: 15
					},
					{
						name: "Avatar",
						value: 16
					},
					{
						name: "Input",
						value: 17
					},
					{
						name: "Environment",
						value: 18
					},
					{
						name: "RemoteEvent",
						value: 19
					},
					{
						name: "LegacySound",
						value: 20
					},
					{
						name: "Players",
						value: 21
					},
					{
						name: "CapabilityControl",
						value: 22
					},
					{
						name: "Plugin",
						value: 23
					},
					{
						name: "LocalUser",
						value: 24
					},
					{
						name: "WritePlayer",
						value: 25
					},
					{
						name: "RobloxScript",
						value: 26
					},
					{
						name: "RobloxEngine",
						value: 27
					},
					{
						name: "Unassigned",
						value: 28
					},
					{
						name: "InternalTest",
						value: 29
					},
					{
						name: "PluginOrOpenCloud",
						value: 30
					},
					{
						name: "Assistant",
						value: 31
					},
					{
						name: "RemoteCommand",
						value: 32
					},
					{
						name: "AssetRead",
						value: 33
					},
					{
						name: "AssetManagement",
						value: 34
					},
					{
						name: "DynamicGeneration",
						value: 35
					},
					{
						name: "PlatformAvatarEditing",
						value: 36
					},
					{
						name: "AssetCreateUpdate",
						value: 37
					},
					{
						name: "Capture",
						value: 38
					},
					{
						name: "SensitiveInput",
						value: 39
					},
					{
						name: "Monetization",
						value: 40
					},
					{
						name: "LoadOwnedAsset",
						value: 41
					},
					{
						name: "Social",
						value: 42
					},
					{
						name: "ServerCommunication",
						value: 43
					},
					{
						name: "Logging",
						value: 44
					},
					{
						name: "PromptExternalPurchase",
						value: 45
					},
					{
						name: "Groups",
						value: 46
					},
					{
						name: "Teleport",
						value: 47
					},
					{
						name: "Consequences",
						value: 48
					},
					{
						name: "Material",
						value: 49
					},
					{
						name: "AvatarBehavior",
						value: 50
					},
					{
						name: "AvatarAppearance",
						value: 51
					},
					{
						name: "LoadUnownedAsset",
						value: 52
					}
				],
				tags: []
			}
		];
	}
}
