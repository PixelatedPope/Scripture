/// @description
event_inherited();
registry = ds_map_create();

///@func getList(key)
getList = function(_key){
  return registry[? _key];  
}

///@func addList(_key);
addList = function(_key){
  _list = ds_list_create();
  ds_map_add_list(registry,_key,_list);
  return _list;
}

///@func findEventIndex(list, _id)
findEventIndex = function(_list, _id){
  for(var _i = 0; _i < ds_list_size(_list); _i++) {
    var _event = _list[| _i];
    if(_event.id == _id) return _i;
  }
  return -1;
}

///@func addListener(id, key, callback, [onlyOnce = false])
addListener = function(_id, _key, _callback, _onlyOnce = false) {
  var _list = getList(_key);
  if(_list == undefined)
    _list = addList(_key)
  
  if(findEventIndex(_list, _id) != -1) return;
  
  ds_list_add(_list, {id: _id, callback: _callback, onlyOnce: _onlyOnce});
}

///@func stopListening(id, key)
stopListening = function(_id, _key, _remove) {
	if(!ds_exists(registry,ds_type_map)) exit;
  var _list = registry[? _key];
  if(_list == undefined)
    return;
		
  var _i = findEventIndex(_list, _id);
  if(_i == -1) return;
  ds_list_delete(_list, _i);
}

///@func raiseEvent(key, [options])
raiseEvent = function(_key, _options = {}){
  var _list = getList(_key);
  if(_list == undefined) return;
  
  for(var _i = 0; _i < ds_list_size(_list); _i++) {
    var _event = _list[| _i];
		if(instance_exists(_event.id))
			_event.callback(_options);
		
		if(_event.onlyOnce) {
			ds_list_delete(_list, _i);
			_i--;
		}
  }
}