package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import lime.utils.Assets;

using StringTools;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = -1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	// private var iconArray:Array<AttachedSprite> = [];
	private var creditsStuff:Array<Array<String>> = [];

	var bg:FlxSprite;
	var descText:FlxText;
	var intendedColor:Int;
	var colorTween:FlxTween;
	var descBox:AttachedSprite;

	var offsetThing:Float = -75;

	var arrow:FlxSprite;
	var memberIcon:FlxSprite;
	var teamName:FlxText;
	var role:FlxText;
	var memberName:FlxText;
	var memberCharacter:FlxSprite;

	var pressTimer:Int;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		persistentUpdate = true;
		bg = new FlxSprite().loadGraphic(Paths.image('creditBG'));
		add(bg);
		bg.screenCenter();

		var creditBGCover:FlxSprite = new FlxSprite().loadGraphic(Paths.image('creditBGCover'));
		add(creditBGCover);
		creditBGCover.screenCenter();

		arrow = new FlxSprite();
		arrow.frames = Paths.getSparrowAtlas('creditArrow');
		arrow.updateHitbox();
		arrow.animation.addByPrefix('basic', 'basic');
		arrow.animation.addByPrefix('start', 'start');
		arrow.animation.addByPrefix('end', 'end');
		arrow.animation.addByPrefix('up', 'UP');
		arrow.animation.addByPrefix('down', 'DOWN');
		arrow.animation.play('basic');
		add(arrow);

		descText = new FlxText(50, FlxG.height + offsetThing - 25, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER/*, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK*/);
		
		grpOptions = new FlxTypedGroup<Alphabet>();
		// add(grpOptions);

		#if MODS_ALLOWED
		var path:String = 'modsList.txt';
		if(FileSystem.exists(path))
		{
			var leMods:Array<String> = CoolUtil.coolTextFile(path);
			for (i in 0...leMods.length)
			{
				if(leMods.length > 1 && leMods[0].length > 0) {
					var modSplit:Array<String> = leMods[i].split('|');
					if(!Paths.ignoreModFolders.contains(modSplit[0].toLowerCase()) && !modsAdded.contains(modSplit[0]))
					{
						if(modSplit[1] == '1')
							pushModCreditsToList(modSplit[0]);
						else
							modsAdded.push(modSplit[0]);
					}
				}
			}
		}

		var arrayOfFolders:Array<String> = Paths.getModDirectories();
		arrayOfFolders.push('');
		for (folder in arrayOfFolders)
		{
			pushModCreditsToList(folder);
		}
		#end

		var pisspoop:Array<Array<String>> = [ //Name - Icon name - Description - Link - BG Color
			['Chri_Dog',            'chriDog',          'Artist\nAnimator\nDirector',                                           '',                                     '',     'Phobos Mod',                 'chriDog'],
			// ['Jipsa',               'jipsa',            'Character motion',                                                     '',                                     '',     'Phobos Mod',                 'jipsa'],
			['Micky',               'micky',            'Artist\nAnimator',                                                     '',                                     '',     'Phobos Mod',                 'micky'],
			['LK',                  'lk',               'Artist',                                                               '',                                     '',     'Phobos Mod',                 'lk'],
			['Bamsquid',            'bamsquid',         'Artist\nIdea',                                                         '',                                     '',     'Phobos Mod',                 'bamsquid'],
			// ['Grape',               'grape',            'Artist\nAnimator',                                                     '',                                     '',     'Phobos Mod',                 'grape'],
			['Square Bracket',      'squareBracket',    'Programmer',                                                           '',                                     '',     'Phobos Mod',                  null],
			['Chung',               'chung',            'Artist\nAnimator',                                                     '',                                     '',     'Phobos Mod',                 'chung'],
			['Raling',              'raling',           'Composer',                                                             '',                                     '',     'Phobos Mod',                 'raling'],
			['Nick',                'nick',             'Artist',                                                               '',                                     '',     'Phobos Mod',                 'nick'],
			['Riodin',              'riodin',           'Cut Scene',                                                            '',                                     '',     'Phobos Mod',                 'riodin'],
			['Daipen',              'daipen',           'Artist',                                                               '',                                     '',     'Phobos Mod',                 null],
			['Gamemon',             'gamemon',          'Trailer',                                                              '',                                     '',     'Phobos Mod',                 'gamemon'],
			['Shadow Mario',		'shadowmario',		'Main Programmer\nof Psych Engine',					            		'https://twitter.com/Shadow_Mario_',	'',     'Psych Engine Team',           null],
			['RiverOaken',			'riveroaken',		'Main Artist/Animator\nof Psych Engine',			         			'https://twitter.com/RiverOaken',		'',     'Psych Engine Team',           null],
			['shubs',				'shubs',			'Additional\nProgrammer\nof Psych Engine',			            		'https://twitter.com/yoshubs',			'',     'Psych Engine Team',           null],
			['bb-panzu',			'bb-panzu',			'Ex-Programmer\nof Psych Engine',				            			'https://twitter.com/bbsub3',			'',     'Former Engine\nMembers',      null],
			['iFlicky',				'iflicky',			'Composer\nof Psync and Tea Time\nMade the\nDialogue Sounds',       	'https://twitter.com/flicky_i',			'',     'Engine Contributors',         null],
			['SqirraRNG',			'gedehari',			'Chart Editor\'s\nSound Waveform\nbase',			        			'https://twitter.com/gedehari',			'',     'Engine Contributors',         null],
			['PolybiusProxy',		'polybiusproxy',	'.MP4 Video\nLoader Extension',						             		'https://twitter.com/polybiusproxy',	'',     'Engine Contributors',         null],
			['Keoiki',				'keoiki',			'Note Splash\nAnimations',							             		'https://twitter.com/Keoiki_',			'',     'Engine Contributors',         null],
			['Smokey',				'smokey',			'Spritemap\nTexture Support',					             			'https://twitter.com/Smokey_5_',		'',     'Engine Contributors',         null],
			['ninjamuffin99',		'ninjamuffin99',	"Programmer\nof Friday Night Funkin'",			            			'https://twitter.com/ninja_muffin99',	'',     "Funkin' Crew",                null],
			['PhantomArcade',		'phantomarcade',	"Animator\nof Friday Night Funkin'",					        		'https://twitter.com/PhantomArcade3K',	'',     "Funkin' Crew",                null],
			['evilsk8r',			'evilsk8r',			"Artist\nof Friday Night Funkin'",						            	'https://twitter.com/evilsk8r',			'',     "Funkin' Crew",                null],
			['kawaisprite',			'kawaisprite',		"Composer\nof Friday Night Funkin'",						        	'https://twitter.com/kawaisprite',		'',     "Funkin' Crew",                null]
		];
		
		for(i in pisspoop){
			creditsStuff.push(i);
		}
	
		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(0, 70 * i, creditsStuff[i][0], !isSelectable, false);
			optionText.isMenuItem = true;
			optionText.screenCenter(X);
			optionText.yAdd -= 70;
			if(isSelectable) {
				optionText.x -= 70;
			}
			optionText.forceX = optionText.x;
			//optionText.yMult = 90;
			optionText.targetY = i;
			// grpOptions.add(optionText);

			if(isSelectable) {
				if(creditsStuff[i][5] != null)
				{
					Paths.currentModDirectory = creditsStuff[i][5];
				}

				// var icon:AttachedSprite = new AttachedSprite('credits/' + creditsStuff[i][1]);
				// icon.xAdd = optionText.width + 10;
				// icon.sprTracker = optionText;
	
				// // using a FlxGroup is too much fuss!
				// iconArray.push(icon);
				// add(icon);
				Paths.currentModDirectory = '';

				if(curSelected == -1) curSelected = i;
			}
		}

		memberCharacter = new FlxSprite(850, 50);
		memberCharacter.loadGraphic(Paths.image('credits/characters/Character-' + creditsStuff[0][6]));
		add(memberCharacter);

		memberIcon = new FlxSprite(130, 300);
		memberIcon.loadGraphic(Paths.image('credits/' + creditsStuff[0][1]));
		add(memberIcon);

		teamName = new FlxText(-110, 100, FlxG.width, "", 20);
		teamName.setFormat(Paths.font("impact.ttf"), 40, FlxColor.RED, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.WHITE);
		teamName.text = creditsStuff[0][5];
		add(teamName);

		role = new FlxText(-110, 300, FlxG.width, "", 20);
		role.setFormat(Paths.font("impact.ttf"), 40, FlxColor.WHITE, CENTER/*,FlxTextBorderStyle.OUTLINE, FlxColor.RED*/);
		role.text = creditsStuff[0][2];
		add(role);

		memberName = new FlxText(375, 550, FlxG.width, "", 20);
		memberName.setFormat(Paths.font("impact.ttf"), 50, FlxColor.WHITE, CENTER/*,FlxTextBorderStyle.OUTLINE, FlxColor.RED*/);
		memberName.text = creditsStuff[0][0];
		add(memberName);
		
		descBox = new AttachedSprite();
		descBox.makeGraphic(1, 1, FlxColor.BLACK);
		descBox.xAdd = -10;
		descBox.yAdd = -10;
		descBox.alphaMult = 0.6;
		descBox.alpha = 0.6;
		// add(descBox);

		descText = new FlxText(50, FlxG.height + offsetThing - 25, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER/*, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK*/);
		descText.scrollFactor.set();
		//descText.borderSize = 2.4;
		descBox.sprTracker = descText;
		// add(descText);

		// bg.color = getCurrentBGColor();
		// intendedColor = bg.color;
		changeSelection();
		super.create();
	}

	var quitting:Bool = false;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		memberIcon.loadGraphic(Paths.image('credits/' + creditsStuff[curSelected][1]));
		memberIcon.updateHitbox();

		teamName.text = creditsStuff[curSelected][5];
		role.text = creditsStuff[curSelected][2];
		memberName.text = creditsStuff[curSelected][0];
		//850, 50

		if (creditsStuff[curSelected][6] == null) {
			memberCharacter.loadGraphic(Paths.image('credits/' + creditsStuff[curSelected][1]));
			memberCharacter.updateHitbox();
			memberCharacter.x = 950;
			memberCharacter.y = 160;
		} else {
			memberCharacter.x = 850;
			memberCharacter.y = 50;
			memberCharacter.loadGraphic(Paths.image('credits/characters/Character-' + creditsStuff[curSelected][6]));
			memberCharacter.updateHitbox();
		}

		if (pressTimer < 0) {
			if (curSelected == 0) arrow.animation.play('start');
			else if (curSelected == creditsStuff.length - 1) arrow.animation.play('end');
			else arrow.animation.play('basic');
		}

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if(!quitting)
		{
			if(creditsStuff.length > 1)
			{
				var shiftMult:Int = 1;
				if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

				var upP = controls.UI_UP_P;
				var downP = controls.UI_DOWN_P;

				if (upP && curSelected != 0)
				{
					arrow.animation.play('up');
					changeSelection(-1 * shiftMult);
					holdTime = 0;
				}
				if (downP && curSelected != creditsStuff.length - 1)
				{
					arrow.animation.play('down');
					changeSelection(1 * shiftMult);
					holdTime = 0;
				}

				if (controls.UI_DOWN || controls.UI_UP)
				{
					pressTimer = 5;
					var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
					holdTime += elapsed;
					var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

					if (holdTime > 0.5 && checkNewHold - checkLastHold > 0)
					{
						changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					}
				}
			}

			if(controls.ACCEPT) {
				CoolUtil.browserLoad(creditsStuff[curSelected][3]);
			}
			if (controls.BACK)
			{
				if(colorTween != null) {
					colorTween.cancel();
				}
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
				quitting = true;
			}
		}
		
		for (item in grpOptions.members)
		{
			if(!item.isBold)
			{
				var lerpVal:Float = CoolUtil.boundTo(elapsed * 12, 0, 1);
				if(item.targetY == 0)
				{
					var lastX:Float = item.x;
					item.screenCenter(X);
					item.x = FlxMath.lerp(lastX, item.x - 70, lerpVal);
					item.forceX = item.x;
				}
				else
				{
					item.x = FlxMath.lerp(item.x, 200 + -40 * Math.abs(item.targetY), lerpVal);
					item.forceX = item.x;
				}
			}
		}
		pressTimer--;
		super.update(elapsed);
	}

	var moveTween:FlxTween = null;
	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var newColor:Int =  getCurrentBGColor();
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			// colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
			// 	onComplete: function(twn:FlxTween) {
			// 		colorTween = null;
			// 	}
			// });
		}

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}
			}
		}

		descText.text = creditsStuff[curSelected][2];
		descText.y = FlxG.height - descText.height + offsetThing - 60;

		if(moveTween != null) moveTween.cancel();
		moveTween = FlxTween.tween(descText, {y : descText.y + 75}, 0.25, {ease: FlxEase.sineOut});

		descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
		descBox.updateHitbox();
	}

	#if MODS_ALLOWED
	private var modsAdded:Array<String> = [];
	function pushModCreditsToList(folder:String)
	{
		if(modsAdded.contains(folder)) return;

		var creditsFile:String = null;
		if(folder != null && folder.trim().length > 0) creditsFile = Paths.mods(folder + '/data/credits.txt');
		else creditsFile = Paths.mods('data/credits.txt');

		if (FileSystem.exists(creditsFile))
		{
			var firstarray:Array<String> = File.getContent(creditsFile).split('\n');
			for(i in firstarray)
			{
				var arr:Array<String> = i.replace('\\n', '\n').split("::");
				if(arr.length >= 5) arr.push(folder);
				creditsStuff.push(arr);
			}
			creditsStuff.push(['']);
		}
		modsAdded.push(folder);
	}
	#end

	function getCurrentBGColor() {
		var bgColor:String = creditsStuff[curSelected][4];
		if(!bgColor.startsWith('0x')) {
			bgColor = '0xFF' + bgColor;
		}
		return Std.parseInt(bgColor);
	}

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}