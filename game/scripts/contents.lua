--this script will control the contents of the page
function getLocale()
  local locale
  locale='loc'..mapLocale
  overlay=nil
  if map[locale]==nil then createMap(locale) end
  if map[locale].type=='forest' then bg1n,bg2n,bg3n=75,160,75 end
  if map[locale].type=='grove' then 
    bg1n,bg2n,bg3n=100,130,100
  end
end