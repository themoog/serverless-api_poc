from flask import Flask, request, jsonify, abort

app = Flask(__name__)

availableSources = {
    "5d370b1f14e20692ddbe7c79": {  # Mock MWEdge ID
        "URL_ENCODED_SOURCE_ID": {  # Mock source ID
            "name": "Initial",
            "stream": "initial_stream",
            "tags": "initial_tags",
            "etr290Enabled": False,
            "options": {},
            "paused": False,
            "priority": 5,
            "exhausted": False,
            "active": False,
            "protocol": "InitialProtocol"
        }
    }
}

@app.route('/api/mwedge/<mwedge_id>/source/<source_id>', methods=['PUT'])
def update_source(mwedge_id, source_id):
    if 'Authorization' not in request.headers:
        return jsonify({"error": "No authorization token"}), 401

    if mwedge_id not in availableSources or source_id not in availableSources[mwedge_id]:
        return jsonify({"error": "MWEdge or source not found"}), 404

    data = request.json
    source = availableSources[mwedge_id][source_id]

    # Update source properties based on request data
    for key in data:
        if key in source:
            source[key] = data[key]

    return jsonify(source), 200


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)

