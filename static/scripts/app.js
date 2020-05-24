(function(){

let user = window.location.href;
user = user.split('/').pop();
async function createUserMap(user){
    try {
        let countries = await axios.get('/albums', {params: {username: user}});
        countries = countries.data;
        let data = countries
        let map = new jvm.Map({
            container: $('#world-map'),
            map: "world_mill",
            backgroundColor: 'rgba(0,0,0,0)',
            regionStyle: {
                initial: {
                    fill:'#99ff99',
                    stroke: 'black',
                    'stroke-width': '.5px'
                }
            },
            series: {
                regions: [{
                    values: data,
                    attribute: 'fill',
                    scale: ['#99ff99', '#009933'],
                    normalizeFunction: 'polynomial'
                }]
            },
            onRegionTipShow: function(e, el, code) {
                el.html(el.html() + `<p class="mb-0">Albums: ${data[code] || 0}</p>`);
            },
            onRegionClick: function(e, code) {
                if (user) {
                    window.location = window.location + `/albums/${code}`
                }
            }
        })
    }
    
    catch (e) {
        console.log(e);
    }
};

createUserMap(user)
})()