(function ($, pf, L) {
    pf.modules.map = {};
    $.extend(pf.modules.map, {

        _map: null,

        init: function () {
            this.setDom();

            this._map = this.buildMap();
            pf.viewmodel.map = this._map;

            this.setInitialView();
        },


        setDom: function () {
            pf.view.$map = $('#map');
        },


        buildMap: function () {
            return L.extremum.map('map', '/static/contrib/extremum-maps/layers.json');
        },


        setInitialView: function () {
            this._map.setView([59.9375, 30.3086], 9);
        }
    });
}(jQuery, pf, L));