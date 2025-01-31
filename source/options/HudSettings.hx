package options;

class HudSettings extends BaseOptionsMenu{

public function new()
        {
            title = 'Hud Settings';
            rpcTitle = 'Huh Settings'; //for Discord Rich Presence
        
            var option:Option = new Option('icons in border',
            "If enabled, the icons will not move and will remain on \nthe edge of the health bar.",
            'iconsBor',
            'bool',
            false);
            addOption(option);

            addOption(option);
            var option:Option = new Option('show health',
            'shows the current health percentage',
            'shitHealth',
            'bool',
            false);
            addOption(option);
            var option:Option = new Option('GF icon',
            'If it is activated you will be able to see your \ngirlfriend icon in the hud.',
            'gfIcon',
            'bool',
            true);
        addOption(option);
            
           
super();
}
}